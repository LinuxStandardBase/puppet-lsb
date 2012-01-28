class buildbot::slave inherits buildbot {

    # Here, we figure out what user and password to use to log into the
    # master.  This differs per-architecture.

    $masteruser = $architecture ? {
        /^i386$/ => 'lfbuild-x86',
    }

    # XXX: need to set up secrets Puppet modules.
    $masterpw = 'invalid'

    # Which SDKs should we use for released and beta builds?

    $releasedsdk = $architecture ? {
        /^i386$/ => 'lsb-sdk-4.1.2-1.ia32.tar.gz',
    }

    $releasedsdkpath = 'bundles/released-4.1.0/sdk'

    $betasdk = $releasedsdk

    $betasdkpath = $releasedsdkpath

    # Include required packages for builds here.  Some of these
    # might be included from the base buildbot class; check init.pp
    # for those.

    include bzr

    # XXX: make should be its own module, since it's used in a few
    # places.
    #package { 'make':
    #    ensure => present,
    #}

    package { 'rpm-devel':
        ensure => present,
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
        command => "/opt/buildbot/bin/buildslave create-slave --umask=022 /opt/buildbot/lsb-slave vm1.linuxbase.org $masteruser $masterpw",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lsb-slave/buildbot.tac",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin", "/usr/local/bin" ],
        user    => 'buildbot',
        require => [ Exec["make-buildslave"], File["/opt/buildbot/lsb-slave"] ],
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

}
