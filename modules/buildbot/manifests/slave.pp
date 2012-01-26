class buildbot::slave inherits buildbot {

    exec { "make bin/buildslave":
        cwd => "/opt/buildbot",
        creates => "/opt/buildbot/bin/buildslave",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => File["/opt/buildbot/Makefile"],
    }

}
