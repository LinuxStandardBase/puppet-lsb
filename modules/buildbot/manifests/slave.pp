class buildbot::slave inherits buildbot {

    exec { "make-buildslave":
        command => "/opt/buildbot/bin/pip install buildbot-slave==$buildbotversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/bin/buildslave",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => Exec["make-buildbot-virtualenv"],
    }

}
