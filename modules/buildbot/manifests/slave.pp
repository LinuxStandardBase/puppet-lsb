class buildbot::slave inherits buildbot {

    exec { "make-buildslave":
        command => "/opt/buildbot/bin/pip install buildbot-slave==$buildbotversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lib/python2.6/site-packages/buildbot_slave-$buildbotversion-py2.6.egg-info",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => Exec["make-buildbot-virtualenv"],
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

}
