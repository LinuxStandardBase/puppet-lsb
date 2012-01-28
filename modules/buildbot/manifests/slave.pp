class buildbot::slave inherits buildbot {

    exec { "make-buildslave":
        command => "/opt/buildbot/bin/pip install buildbot-slave==$buildbotversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lib/python2.6/site-packages/buildbot_slave-$buildbotversion-py2.6.egg-info",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => Exec["make-buildbot-virtualenv"],
    }

}
