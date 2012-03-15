class buildbot::slave inherits buildbot {

    include buildbot::virtualenv

    # Slave package info has its own module.
    include buildbot::slavepkgs

    # We need the sudo setup for buildbot
    include sudo

    # Here, we figure out what user and password to use to log into the
    # master.  This differs per-architecture.  The buildbotpw module
    # is pulled in from puppet-secret, and just contains Puppet variables
    # containing passwords.  The defaults are used by chroot build slaves,
    # which are managed differently (see the manifest for the class
    # buildbot::slavechroot).

    include buildbotpw

    $masteruser = $architecture ? {
        /^i386$/   => 'lfbuild-x86',
        /^x86_64$/ => 'lfbuild-x86_64',
        /^ia64$/   => 'lfbuild-ia64',
        default    => $buildbotpw::masteruser,
    }

    $masterpw = $architecture ? {
        /^i386$/   => $buildbotpw::x86password,
        /^x86_64$/ => $buildbotpw::x64password,
        /^ia64$/   => $buildbotpw::ia64password,
        default    => $buildbotpw::masterpw,
    }

    # Which SDKs should we use for released and beta builds?

    $releasedsdk = "$architecture-$::chroot" ? {
        /^i386/         => 'lsb-sdk-4.1.2-1.ia32.tar.gz',
        /^x86_64/       => 'lsb-sdk-4.1.2-1.x86_64.tar.gz',
        /^ia64/         => 'lsb-sdk-4.1.2-1.ia64.tar.gz',
        /^s390x-small$/ => 'lsb-sdk-4.1.2-1.s390.tar.gz',
        /^s390x-big$/   => 'lsb-sdk-4.1.2-1.s390x.tar.gz',
        /^ppc64-small$/ => 'lsb-sdk-4.1.2-1.ppc32.tar.gz',
        /^ppc64-big$/   => 'lsb-sdk-4.1.2-1.ppc64.tar.gz',
    }

    $releasedsdkpath = 'bundles/released-4.1.0/sdk'

    $betasdk = $releasedsdk

    $betasdkpath = $releasedsdkpath

    # Special downloaded packages needed for builds from the LSB.
    # XXX: this should migrate to using package repositories and
    #      the package resource in puppet.

    $lsbpythonurl = "$architecture-$::chroot" ? {
        /^i386/         => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/ia32/lsb-python-2.4.6-5.lsb4.i486.rpm',
        /^x86_64/       => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/amd64/lsb-python-2.4.6-5.lsb4.x86_64.rpm',
        /^ia64/         => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/ia64/lsb-python-2.4.6-5.lsb4.ia64.rpm',
        /^s390x-small$/ => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/s390/lsb-python-2.4.6-5.lsb4.s390.rpm',
        /^s390x-big$/   => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/s390x/lsb-python-2.4.6-5.lsb4.s390x.rpm',
        /^ppc64-small$/ => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/ppc32/lsb-python-2.4.6-5.lsb4.ppc.rpm',
        /^ppc64-big$/   => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/ppc64/lsb-python-2.4.6-5.lsb4.ppc64.rpm',
    }

    $appchkpyurl = 'http://ftp.linuxfoundation.org/pub/lsb/test_suites/released-all/binary/application/lsb-appchk-python-4.1.0-1.noarch.rpm'

    # Include required packages for builds here.  Some of these
    # might be included from the base buildbot class; check init.pp
    # for those.

    include bzr

    # XXX: make should be its own module, since it's used in a few
    # places.
    #package { 'make':
    #    ensure => present,
    #}

    define install-xdevel() {
        package { "${name}": ensure => installed }
    }

    install-xdevel { $buildbot::slavepkgs::xdevelpkg: }

    # On Red Hat systems, this is the same package as $bdftocfpkg.
    if $operatingsystem !~ /^(Fedora|CentOS)$/ {
        package { "$buildbot::slavepkgs::ucs2anypkg":
            ensure => present,
        }
    }

    # Declare most of the package dependencies from buildbot::slavepkgs
    # in one fell swoop.

    package { $buildbot::slavepkgs::pkglist:
        ensure => present,
    }

    # Get special LSB packages needed for builds.

    exec { "download-lsb-python":
        command => "wget -O lsb-python.rpm $lsbpythonurl",
        cwd     => '/opt/buildbot',
        creates => '/opt/buildbot/lsb-python.rpm',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Package['wget'],
    }

    exec { 'install-lsb-python':
        command => 'rpm -Uvh /opt/buildbot/lsb-python.rpm',
        creates => '/opt/lsb/appbat/bin/python',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['download-lsb-python'],
    }

    exec { "download-lsbappchk-python":
        command => "wget -O lsbappchk-python.rpm $appchkpyurl",
        cwd     => '/opt/buildbot',
        creates => '/opt/buildbot/lsbappchk-python.rpm',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Package['wget'],
    }

    exec { 'install-lsbappchk-python':
        command => 'rpm -Uvh /opt/buildbot/lsbappchk-python.rpm',
        creates => '/opt/lsb/bin/lsbappchk.py',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['download-lsbappchk-python'],
    }

    # Other packages needed by this puppet module.

    package { 'wget':
        ensure => present,
    }

    # Set up the base infrastructure.    

    file { "/opt/buildbot/lsb-slave":
        ensure => directory,
        owner  => 'buildbot',
    }

    exec { "make-buildslave":
        command => "/opt/buildbot/bin/pip install buildbot-slave==$buildbotversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lib/python$pythonversion/site-packages/buildbot_slave-$buildbotversion-py$pythonversion.egg-info",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin" ],
        require => Exec["make-buildbot-virtualenv"],
    }

    exec { "make-slave":
        command => "/opt/buildbot/bin/buildslave create-slave --umask=022 /opt/buildbot/lsb-slave vm1.linuxbase.org:9989 $masteruser $masterpw",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lsb-slave/buildbot.tac",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin", "/usr/local/bin" ],
        user    => 'buildbot',
        require => [ Exec["make-buildslave"], File["/opt/buildbot/lsb-slave"] ],
    }

    file { "/opt/buildbot/lsb-slave/info/admin":
        content => "LSB Workgroup <lsb-discuss@lists.linuxfoundation.org>\n",
        require => Exec['make-slave'],
        notify  => Service['buildslave'],
    }

    file { "/opt/buildbot/lsb-slave/info/host":
        content => "Host $fqdn, running $operatingsystem $operatingsystemrelease on $architecture.\n",
        require => Exec['make-slave'],
        notify  => Service['buildslave'],
    }

    exec { "set-slave-pw":
        command => "sed 's/^passwd[[:space:]]*=.*$/passwd = \"$masterpw\"/' < /opt/buildbot/lsb-slave/buildbot.tac > /opt/buildbot/lsb-slave/buildbot.tac.new && rm /opt/buildbot/lsb-slave/buildbot.tac && mv /opt/buildbot/lsb-slave/buildbot.tac.new /opt/buildbot/lsb-slave/buildbot.tac",
        cwd     => '/opt/buildbot',
        path    => [ '/opt/buildbot/bin', '/bin', '/sbin', '/usr/bin',
                     '/usr/sbin' ],
        user    => 'buildbot',
        require => Exec['make-slave'],
        onlyif  => "[ $(grep -c $masterpw /opt/buildbot/lsb-slave/buildbot.tac) -eq 0 ]",
        notify  => Service['buildslave'],
    }

    file { "/usr/local/bin/reset-sdk":
        source => "puppet:///modules/buildbot/slavescripts/reset-sdk",
        mode   => 0755,
    }

    file { "/usr/local/bin/update-sdk":
        source => "puppet:///modules/buildbot/slavescripts/update-sdk",
        mode   => 0755,
    }

    file { "/usr/local/bin/run-appbat-tests":
        source => "puppet:///modules/buildbot/slavescripts/run-appbat-tests",
        mode   => 0755,
    }

    exec { 'download-released-sdk':
        command => "wget http://ftp.linuxbase.org/pub/lsb/$releasedsdkpath/$releasedsdk",
        cwd     => '/opt/buildbot',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => "/opt/buildbot/$releasedsdk",
        require => [ Package['wget'], File['/opt/buildbot'] ],
        notify  => File['/opt/buildbot/lsb-released-sdk.tar.gz'],
    }

    file { '/opt/buildbot/lsb-released-sdk.tar.gz':
        ensure => link,
        target => "/opt/buildbot/$releasedsdk",
    }

    exec { 'download-beta-sdk':
        command => "wget http://ftp.linuxbase.org/pub/lsb/$betasdkpath/$betasdk",
        cwd     => '/opt/buildbot',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => "/opt/buildbot/$betasdk",
        require => [ Package['wget'], File['/opt/buildbot'] ],
        notify  => File['/opt/buildbot/lsb-beta-sdk.tar.gz'],
    }

    file { '/opt/buildbot/lsb-beta-sdk.tar.gz':
        ensure => link,
        target => "/opt/buildbot/$betasdk",
    }

    file { "/etc/init.d/buildslave":
        ensure  => present,
        content => template("buildbot/buildslave.init.erb"),
        mode    => 0755,
        notify  => Service['buildslave'],
    }

    service { "buildslave":
        ensure     => running,
        hasrestart => false,
        hasstatus  => false,
        require    => [ File['/etc/init.d/buildslave'], User['buildbot'],
                        Exec['make-slave'] ],
    }

    # Special: for small-word chroot build slaves, we need to force
    # small-word builds (31- or 32-bit builds).  The source for gcc-wrapper
    # is actually created by buildbot::slavechroot; see its definition there.

    if $chroot == 'small' {

        $smallwordcmd = $architecture ? {
            's390x' => 's390',
            'ppc64' => 'powerpc32',
        }

        package { $smallwordpkg: ensure => present }

        file { '/usr/bin/gcc-wrapper':
            source => 'puppet:///modules/buildbot/gcc-wrapper',
            mode   => 0755,
        }

        file { '/usr/bin/gcc':
            ensure  => link,
            target  => 'gcc-wrapper',
            require => File['/usr/bin/gcc-wrapper'],
        }

        file { '/usr/bin/g++':
            ensure  => link,
            target  => 'gcc-wrapper',
            require => File['/usr/bin/gcc-wrapper'],
        }

    }

}
