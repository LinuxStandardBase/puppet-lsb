class buildbot::slave inherits buildbot {

    include miscpkgs::wget
    include buildbot::virtualenv

    # Security precaution; we should protect all slaves this way.
    include fail2ban

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

    # Where's the master?

    $buildbotmaster = 'vm3.linuxbase.org'
    $buildbotport = '9989'

    # 32-bit versions of some architectures don't exist as
    # native platforms themselves; they run almost entirely
    # on the 64-bit version.  For these, we have to figure
    # out whether we're building on the "big" or "small"
    # version of the architecture.  This is indicated for
    # build slaves using chroots for us; for non-chroot
    # build slaves, we need to find that out for ourselves.

    if $chroot != "" {
        $wordsize = $chroot
    } else {
        $wordsize = $hostname ? {
            'linfnd1'             => 'big',
            'linfnd2'             => 'small',
            'lfdev-build-power32' => 'small',
            'lfdev-build-power64' => 'big',
            'lsb-k-b-s390'        => 'small',
            'lsb-x-s390'          => 'small',
            'lsb-k-b-s390x'       => 'big',
            'lsb-x-b-s390x'       => 'big',
            default               => '',
        }
    }

    # We also have multiple build slaves for s390 and s390x.
    # Figure out which slave we are by looking at the hostname.
    # By default, set ourselves up as #1 unless the hostname
    # matches the hostnames we want as #2; this means that
    # if we switch the #2 build slaves, we need to fix the
    # hostname here.  Also, this means that other archs are
    # set up as #1, which shouldn't matter, but is at least
    # consistent with reality.

    $slaveid = $hostname ? {
        'lsb-x-s390'    => 'two',
        'lsb-x-b-s390x' => 'two',
        default         => 'one',
    }

    # Set up login information.

    $masteruser = "${architecture}-${wordsize}-${slaveid}" ? {
        /^i386/            => 'lfbuild-x86',
        /^x86_64/          => 'lfbuild-x86_64',
        /^ia64/            => 'lfbuild-ia64',
        /^ppc64-small/     => 'lfbuild-ppc32',
        /^ppc64-big/       => 'lfbuild-ppc64',
        /^s390x-small-one/ => 'lfbuild-s390',
        /^s390x-big-one/   => 'lfbuild-s390x',
        /^s390x-small-two/ => 'lfbuild-s390-2',
        /^s390x-big-two/   => 'lfbuild-s390x-2',
        default            => $buildbotpw::masteruser,
    }

    $masterpw = "${architecture}-${wordsize}-${slaveid}" ? {
        /^i386/            => $buildbotpw::x86password,
        /^x86_64/          => $buildbotpw::x64password,
        /^ia64/            => $buildbotpw::ia64password,
        /^ppc64-small/     => $buildbotpw::ppc32password,
        /^ppc64-big/       => $buildbotpw::ppc64password,
        /^s390x-small-one/ => $buildbotpw::s390password,
        /^s390x-big-one/   => $buildbotpw::s390xpassword,
        /^s390x-small-two/ => $buildbotpw::s390pwd2,
        /^s390x-big-two/   => $buildbotpw::s390xpwd2,
        default            => $buildbotpw::masterpw,
    }

    # Which SDKs should we use for released and beta builds?

    $releasedsdk = "${architecture}-${wordsize}" ? {
        /^i386/         => 'lsb-sdk-5.0.0-3.ia32.tar.gz',
        /^x86_64/       => 'lsb-sdk-5.0.0-3.x86_64.tar.gz',
        /^ia64/         => 'lsb-sdk-5.0.0-3.ia64.tar.gz',
        /^s390x-small$/ => 'lsb-sdk-5.0.0-3.s390.tar.gz',
        /^s390x-big$/   => 'lsb-sdk-5.0.0-3.s390x.tar.gz',
        /^ppc64-small$/ => 'lsb-sdk-5.0.0-3.ppc32.tar.gz',
        /^ppc64-big$/   => 'lsb-sdk-5.0.0-3.ppc64.tar.gz',
    }

    $releasedsdkpath = 'bundles/released-5.0.0/sdk'

    # For beta SDKs, most of the time we just want to use
    # the released SDK for the beta SDK.  But when they are
    # actually different, we need to specify that here.
    # Use this set of declarations for a separate beta SDK.

    #$betasdk = "${architecture}-${wordsize}" ? {
    #    /^i386/         => 'lsb-sdk-5.0.0-2.ia32.tar.gz',
    #    /^x86_64/       => 'lsb-sdk-5.0.0-2.x86_64.tar.gz',
    #    /^ia64/         => 'lsb-sdk-5.0.0-2.ia64.tar.gz',
    #    /^s390x-small$/ => 'lsb-sdk-5.0.0-2.s390.tar.gz',
    #    /^s390x-big$/   => 'lsb-sdk-5.0.0-2.s390x.tar.gz',
    #    /^ppc64-small$/ => 'lsb-sdk-5.0.0-2.ppc32.tar.gz',
    #    /^ppc64-big$/   => 'lsb-sdk-5.0.0-2.ppc64.tar.gz',
    #}

    #$betasdkpath = 'bundles/beta/sdk'

    # Use this set of declarations to set the beta SDK
    # to be the same as the released SDK.

    $betasdk = $releasedsdk
    $betasdkpath = $releasedsdkpath

    # Special downloaded packages needed for builds from the LSB.
    # XXX: this should migrate to using package repositories and
    #      the package resource in puppet.

    $lsbpythonurl = "${architecture}-${wordsize}" ? {
        /^i386/         => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/ia32/lsb-python-2.4.6-7.lsb4.i486.rpm',
        /^x86_64/       => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/amd64/lsb-python-2.4.6-7.lsb4.x86_64.rpm',
        /^ia64/         => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/ia64/lsb-python-2.4.6-7.lsb4.ia64.rpm',
        /^s390x-small$/ => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/s390/lsb-python-2.4.6-7.lsb4.s390.rpm',
        /^s390x-big$/   => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/s390x/lsb-python-2.4.6-7.lsb4.s390x.rpm',
        /^ppc64-small$/ => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/ppc32/lsb-python-2.4.6-7.lsb4.ppc.rpm',
        /^ppc64-big$/   => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/ppc64/lsb-python-2.4.6-7.lsb4.ppc64.rpm',
    }

    $appchkpyurl = 'http://ftp.linuxfoundation.org/pub/lsb/test_suites/released-all/binary/application/lsb-appchk-python-5.0.0-1.noarch.rpm'

    # For small-word build slaves.
    if $wordsize == 'small' {

        $smallwordcmd = $architecture ? {
            's390x' => 's390',
            'ppc64' => 'powerpc32',
        }

    }

    # Include required packages for builds here.  Some of these
    # might be included from the base buildbot class; check init.pp
    # for those.

    include bzr

    include make

    # Packages that need to be absent on slaves.

    package {
        'lsb-build-libbat': ensure => absent;
    }

    define installpkglist() {
        package { "${name}": ensure => installed }
    }

    # Declare most of the package dependencies from buildbot::slavepkgs
    # in one fell swoop.

    installpkglist { $buildbot::slavepkgs::lsbpkg: }

    installpkglist { $buildbot::slavepkgs::xdevelpkg: }

    installpkglist { $buildbot::slavepkgs::fontutilpkg: }

    installpkglist { $buildbot::slavepkgs::pkglist: }

    # 32-bit cross-built arch packages.

    if $wordsize == 'small' {
        package {
            $buildbot::slavepkgs::libc32pkg: ensure => installed;
            $buildbot::slavepkgs::libcstatic32pkg: ensure => installed;
            $buildbot::slavepkgs::cpp32pkg: ensure => installed;
            $buildbot::slavepkgs::zlib32pkg: ensure => installed;
            $buildbot::slavepkgs::ncurses32pkg: ensure => installed;
            $buildbot::slavepkgs::expat32pkg: ensure => installed;
            $buildbot::slavepkgs::gtk32pkg: ensure => installed;
            $buildbot::slavepkgs::png32pkg: ensure => installed;
            $buildbot::slavepkgs::xdevel32pkg: ensure => installed;
        }

        if $operatingsystem == 'Fedora' {
            package {
                $buildbot::slavepkgs::lsb32pkg: ensure => installed;
            }
        } 
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

    # Set up the base infrastructure.    

    file { '/opt/buildbot/.cvspass':
        source => 'puppet:///modules/buildbot/cvspass',
        owner  => 'buildbot',
        mode   => '0600',
    }

    file { "/opt/buildbot/lsb-slave":
        ensure => directory,
        owner  => 'buildbot',
    }

    exec { "install-twisted":
        command => "/opt/buildbot/bin/pip install Twisted==$twistedversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lib/python${pythonversion}/site-packages/twisted/__init__.py",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin" ],
        require => [ Exec["make-buildbot-virtualenv"],
                     Package['python-devel'] ],
    }

    exec { "install-buildslave":
        command => "/opt/buildbot/bin/pip install buildbot-slave==$buildbotversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lib/python${pythonversion}/site-packages/buildbot_slave-${buildbotversion}-py${pythonversion}.egg-info",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin" ],
        require => Exec["install-twisted"],
    }

    # The following command is overriden by buildbot::devchk
    # to work around an issue with Puppet variables.  If we change
    # it, we have to change the overriden one there to match.
    # It's a pain, but hopefully this won't need to change much.

    exec { "make-slave":
        command => "/opt/buildbot/bin/buildslave create-slave --umask=022 /opt/buildbot/lsb-slave ${buildbotmaster}:${buildbotport} $masteruser $masterpw",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lsb-slave/buildbot.tac",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin", "/usr/local/bin" ],
        user    => 'buildbot',
        require => [ Exec["install-buildslave"],
                     File["/opt/buildbot/lsb-slave"] ],
    }

    exec { "update-buildmaster":
        command     => "sed -i 's/^buildmaster_host.*\$/buildmaster_host = \"${buildbotmaster}\"/' /opt/buildbot/lsb-slave/buildbot.tac",
        path        => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require     => Exec["make-slave"],
        notify      => Service["buildslave"],
        refreshonly => true,
    }

    file { "/opt/buildbot/${buildbotmaster}-update":
        ensure => present,
        notify => Exec["update-buildmaster"],
    }

    file { "/opt/buildbot/lsb-slave/info/admin":
        content => "LSB Workgroup <lsb-discuss@lists.linuxfoundation.org>\n",
        require => Exec['make-slave'],
        notify  => Service['buildslave'],
    }

    file { "/opt/buildbot/lsb-slave/info/host":
        content => "Host ${fqdn} (${ipaddress}), running $operatingsystem $operatingsystemrelease on ${architecture}.\n",
        require => Exec['make-slave'],
        notify  => Service['buildslave'],
    }

    file { "/usr/local/bin/reset-sdk":
        source => "puppet:///modules/buildbot/slavescripts/reset-sdk",
        mode   => '0755',
    }

    file { "/usr/local/bin/update-sdk":
        source => "puppet:///modules/buildbot/slavescripts/update-sdk",
        mode   => '0755',
    }

    file { "/usr/local/bin/run-appbat-tests":
        source => "puppet:///modules/buildbot/slavescripts/run-appbat-tests",
        mode   => '0755',
    }

    exec { 'download-released-sdk':
        command => "wget http://ftp.linuxbase.org/pub/lsb/${releasedsdkpath}/${releasedsdk}",
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
        command => "wget http://ftp.linuxbase.org/pub/lsb/${betasdkpath}/${betasdk}",
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

    exec { 'invalidate-installed-sdk':
        command     => '/bin/rm -f /tmp/last_installed_sdk',
        refreshonly => true,
        subscribe   => [ File['/opt/buildbot/lsb-released-sdk.tar.gz'],
                         File['/opt/buildbot/lsb-beta-sdk.tar.gz'] ],
    }

    file { "/etc/init.d/buildslave":
        ensure  => present,
        content => template("buildbot/buildslave.init.erb"),
        mode    => '0755',
        notify  => Service['buildslave'],
    }

    service { "buildslave":
        ensure     => running,
        enable     => true,
        hasrestart => false,
        hasstatus  => true,
        require    => [ File['/etc/init.d/buildslave'], User['buildbot'],
                        Exec['make-slave'] ],
    }

    # Get rid of an old cache that can cause space issues on
    # systems with /tmp mounted tmpfs.

    file { "/tmp/appbat-pkgcache":
        ensure  => absent,
        recurse => true,
        force   => true,
    }

    # Special: for small-word build slaves, we need to force
    # small-word builds (31- or 32-bit builds).  We do this
    # differently for chroots vs. regular build systems.

    if $chroot == 'small' {

        package { $slavepkgs::smallwordpkg: ensure => present }

        file { '/usr/bin/gcc-wrapper':
            source => 'puppet:///modules/buildbot/gcc-wrapper',
            mode   => '0755',
        }

        file { '/usr/bin/ld-wrapper':
            source => 'puppet:///modules/buildbot/ld-wrapper',
            mode   => '0755',
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

        file { '/usr/bin/cc':
            ensure  => link,
            target  => 'gcc-wrapper',
            require => File['/usr/bin/gcc-wrapper'],
        }

        file { '/usr/bin/c++':
            ensure  => link,
            target  => 'gcc-wrapper',
            require => File['/usr/bin/gcc-wrapper'],
        }

        file { '/usr/bin/cc-4.3':
            ensure => link,
            target => 'gcc-4.3',
        }

        file { '/usr/bin/c++-4.3':
            ensure => link,
            target => 'g++-4.3',
        }

        exec { 'move-ld':
            command => '[ -L /usr/bin/ld ] || mv -f /usr/bin/ld /usr/bin/ld.REAL',
            path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        }

        file { '/usr/bin/ld':
            ensure  => link,
            target  => 'ld-wrapper',
            require => [ Exec['move-ld'], File['/usr/bin/ld-wrapper'] ],
        }

    } elsif $wordsize == 'small' {

        $realgcc = '/usr/bin/gcc'

        $realld = '/usr/bin/ld'

        # Pull in values from slavechroot.  Right now, this is
        # just a cut-n-paste; in the future, these should be
        # defined in one common place.

        $smallwordarch = $architecture ? {
            's390x' => 's390',
            'ppc64' => 'ppc',
        }

        $gccsmallword = $architecture ? {
            's390x' => '-m31',
            'ppc64' => '-m32',
        }

        $ldsmallword = $architecture ? {
            's390x' => '-melf_s390',
            'ppc64' => '-melf32ppc',
        }

        package { $slavepkgs::smallwordpkg: ensure => present }

        file { '/usr/local/bin/gcc-wrapper':
            content => template('buildbot/gcc-wrapper.erb'),
            mode    => '0755',
        }

        file { '/usr/local/bin/ld-wrapper':
            content => template('buildbot/ld-wrapper.erb'),
            mode    => '0755',
        }

        file { '/usr/local/bin/gcc':
            ensure => link,
            target => 'gcc-wrapper',
        }

        file { '/usr/local/bin/g++':
            ensure => link,
            target => 'gcc-wrapper',
        }

        file { '/usr/local/bin/cc':
            ensure => link,
            target => 'gcc-wrapper',
        }

        file { '/usr/local/bin/c++':
            ensure => link,
            target => 'gcc-wrapper',
        }

        file { '/usr/local/bin/ld':
            ensure => link,
            target => 'ld-wrapper',
        }

    }

}
