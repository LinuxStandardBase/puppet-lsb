class buildbot::virtualenv {

    include user::buildbot

    include python::virtualenv

    package { 'python-devel':
        ensure => present,
    }

    package { 'gcc':
        ensure => present,
    }

    file { "/opt/buildbot":
        ensure => directory,
        owner  => 'buildbot',
    }

    exec { "make-buildbot-virtualenv":
        command => "virtualenv /opt/buildbot",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/bin/pip",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => [ File["/opt/buildbot"], Package['python-virtualenv'] ],
    }

}
