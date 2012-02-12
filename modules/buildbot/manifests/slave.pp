class buildbot::slave inherits buildbot {

    $lsbpkg = $operatingsystem ? {
        /^Fedora$/ => 'redhat-lsb',
        /^CentOS$/ => 'redhat-lsb',
        default    => 'lsb',
    }

    $rpmpkg = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-.+$/     => 'rpm',
        /^OpenSuSE-.+$/ => 'rpm',
        default         => 'rpm-build',
    }

    $gpluspluspkg = $operatingsystem ? {
        default      => 'gcc-c++',
    }

    $javapkg = $operatingsystem ? {
        /^CentOS/ => 'java-1.6.0-openjdk',
        default   => 'openjdk',
    }

    # Here, we figure out what user and password to use to log into the
    # master.  This differs per-architecture.  The buildbotpw module
    # is pulled in from puppet-secret, and just contains Puppet variables
    # containing passwords.

    include buildbotpw

    $masteruser = $architecture ? {
        /^i386$/   => 'lfbuild-x86',
        /^x86_64$/ => 'lfbuild-x86_64',
    }

    $masterpw = $architecture ? {
        /^i386$/   => $buildbotpw::x86password,
        /^x86_64$/ => $buildbotpw::x64password,
    }

    # Which SDKs should we use for released and beta builds?

    $releasedsdk = $architecture ? {
        /^i386$/   => 'lsb-sdk-4.1.2-1.ia32.tar.gz',
        /^x86_64$/ => 'lsb-sdk-4.1.2-1.x86_64.tar.gz',
    }

    $releasedsdkpath = 'bundles/released-4.1.0/sdk'

    $betasdk = $releasedsdk

    $betasdkpath = $releasedsdkpath

    # Special downloaded packages needed for builds from the LSB.
    # XXX: this should migrate to using package repositories and
    #      the package resource in puppet.

    $lsbpythonurl = $architecture ? {
        /^i386$/   => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/ia32/lsb-python-2.4.6-5.lsb4.i486.rpm',
        /^x86_64$/ => 'http://ftp.linuxfoundation.org/pub/lsb/app-battery/released-4.1/amd64/lsb-python-2.4.6-5.lsb4.x86_64.rpm',
    }

    $lsbteturl = $architecture ? {
        /^i386$/   => 'http://ftp.linuxfoundation.org/pub/lsb/test_suites/released-all/binary/runtime/lsb-tet3-lite-3.7-15.lsb4.i486.rpm',
        /^x86_64$/ => 'http://ftp.linuxfoundation.org/pub/lsb/test_suites/released-all/binary/runtime/lsb-tet3-lite-3.7-15.lsb4.x86_64.rpm',
    }

    $lsbtetdevelurl = $architecture ? {
        /^i386$/   => 'http://ftp.linuxfoundation.org/pub/lsb/test_suites/released-all/binary/runtime/lsb-tet3-lite-devel-3.7-15.lsb4.i486.rpm',
        /^x86_64$/ => 'http://ftp.linuxfoundation.org/pub/lsb/test_suites/released-all/binary/runtime/lsb-tet3-lite-devel-3.7-15.lsb4.x86_64.rpm',
    }

    # Include required packages for builds here.  Some of these
    # might be included from the base buildbot class; check init.pp
    # for those.

    include bzr

    # XXX: make should be its own module, since it's used in a few
    # places.
    #package { 'make':
    #    ensure => present,
    #}

    package { "$lsbpkg":
        ensure => present,
    }

    package { "$rpmpkg":
        ensure => present,
    }

    package { "$gpluspluspkg":
        ensure => present,
    }

    package { 'pkgconfig':
        ensure => present,
    }

    package { "$javapkg":
        ensure => present,
    }

    package { 'autoconf':
        ensure => present,
    }

    package { 'automake':
        ensure => present,
    }

    package { 'libtool':
        ensure => present,
    }

    # XXX: Requiring this is a bug (#3385).
    package { 'ncurses-devel':
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

    exec { "download-lsb-tet":
        command => "wget -O lsb-tet3-lite.rpm $lsbteturl",
        cwd     => '/opt/buildbot',
        creates => '/opt/buildbot/lsb-tet3-lite.rpm',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Package['wget'],
    }

    exec { 'install-lsb-tet':
        command => 'rpm -Uvh /opt/buildbot/lsb-tet3-lite.rpm',
        creates => '/opt/lsb-tet3-lite/bin/tcc',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['download-lsb-tet'],
    }

    exec { "download-lsb-tet-devel":
        command => "wget -O lsb-tet3-lite-devel.rpm $lsbtetdevelurl",
        cwd     => '/opt/buildbot',
        creates => '/opt/buildbot/lsb-tet3-lite-devel.rpm',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Package['wget'],
    }

    exec { 'install-lsb-tet-devel':
        command => 'rpm -Uvh /opt/buildbot/lsb-tet3-lite-devel.rpm',
        creates => '/opt/lsb-tet3-lite/inc',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => [ Exec['download-lsb-python'], Exec['install-lsb-tet'] ],
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
        content => "Host $fqdn, running $operatingsystem $operationsystemrelease on $architecture.\n",
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
        ensure => present,
        source => "puppet:///modules/buildbot/buildslave.init",
        mode   => 0755,
        notify => Service['buildslave'],
    }

    service { "buildslave":
        ensure     => running,
        hasrestart => false,
        hasstatus  => false,
        require    => [ File['/etc/init.d/buildslave'], User['buildbot'],
                        Exec['make-slave'] ],
    }

}
