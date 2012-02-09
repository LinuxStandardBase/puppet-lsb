class buildbot {

    include python::virtualenv

    include user::buildbot

    $buildbotversion = '0.8.5'

    $pythonversion = "$operatingsystem-$operatingsystemrelease" ? {
        /^Fedora-16$/ => '2.7',
        default       => '2.6',
    }

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
        command => "virtualenv --system-site-packages /opt/buildbot",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/bin/pip",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => [ File["/opt/buildbot"], Package['python-virtualenv'] ],
    }

}
