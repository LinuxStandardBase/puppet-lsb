class buildbot::master inherits buildbot {

    exec { "make-buildbot":
        command => "/opt/buildbot/bin/pip install buildbot==$buildbotversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lib/python2.6/site-packages/buildbot-$buildbotversion-py2.6.egg-info",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => Exec["make-buildbot-virtualenv"],
    }

    exec { "make-buildbot-config":
        command => "bzr checkout http://bzr.linuxfoundation.org/lsb/devel/buildbot-config",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/buildbot-config",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => File["/opt/buildbot"],
    }

    file { "/opt/buildbot/lsb-master":
        ensure => directory,
        owner  => 'buildbot',
    }

    exec { "make-master":
        command => "/opt/buildbot/bin/buildbot create-master /opt/buildbot/lsb-master",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lsb-master/buildbot.tac",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        user    => 'buildbot',
        require => [ Exec["make-buildbot"], File["/opt/buildbot/lsb-master"] ],
    }

    file { "/opt/buildbot/lsb-master/master.cfg":
        ensure  => link,
        target  => "../buildbot-config/lsb_master.cfg",
        require => [ Exec['make-buildbot-config'], Exec['make-master'] ],
    }

    file { "/opt/buildbot/lsb-master/bzr_buildbot.py":
        ensure  => link,
        target  => "../buildbot-config/bzr_buildbot.py",
        require => [ Exec['make-buildbot-config'], Exec['make-master'] ],
    }

    file { "/opt/buildbot/lsb-master/lfbuildbot.py":
        ensure  => link,
        target  => "../buildbot-config/lfbuildbot.py",
        require => [ Exec['make-buildbot-config'], Exec['make-master'] ],
    }

    file { "/opt/buildbot/htpasswd":
        ensure => present,
    }

    file { "/etc/init.d/buildbot":
        ensure => present,
        source => "puppet:///modules/buildbot/buildbot.init",
        mode   => 0755,
        notify => Service['buildbot'],
    }

    service { "buildbot":
        ensure     => running,
        hasrestart => false,
        hasstatus  => false,
        require    => User['buildbot'],
    }

}
