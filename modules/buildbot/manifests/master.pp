class buildbot::master inherits buildbot {

    exec { "make bin/buildbot":
        cwd => "/opt/buildbot",
        creates => "/opt/buildbot/bin/buildbot",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => File["/opt/buildbot/Makefile"],
    }

}
