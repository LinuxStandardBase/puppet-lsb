class buildbot::master inherits buildbot {

    exec { "make-buildbot":
        command => "make bin/buildbot",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/bin/buildbot",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => File["/opt/buildbot/Makefile"],
    }

    exec { "make-buildbot-config":
        command => "make buildbot-config",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/buildbot-config",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => File["/opt/buildbot/Makefile"],
    }

    exec { "make-master":
        command => "/opt/buildbot/bin/buildbot create-master /opt/buildbot/lsb-master",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lsb-master",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => Exec["make-buildbot"],
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

}
