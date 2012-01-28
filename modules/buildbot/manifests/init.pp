class buildbot {

    include python::virtualenv

    include user::buildbot

    $buildbotversion = '0.8.5'

    package { 'python-devel':
        ensure => present,
    }

    package { 'gcc':
        ensure => present,
    }

    file { "/opt/buildbot":
        ensure => directory,
    }

    exec { "make-buildbot-virtualenv":
        command => "virtualenv --system-site-packages /opt/buildbot",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/bin/pip",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => File["/opt/buildbot"],
    }

}
