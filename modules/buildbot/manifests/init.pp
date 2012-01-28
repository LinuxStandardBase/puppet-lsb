class buildbot {

    include python::virtualenv

    $buildbotversion = '0.8.5'

    # XXX: make needs to be its own module
    #package { 'make':
    #    ensure => present,
    #}

    package { 'python-devel':
        ensure => present,
    }

    package { 'gcc':
        ensure => present,
    }

    file { "/opt/buildbot":
        ensure => directory,
    }

    file { "/opt/buildbot/Makefile":
        ensure  => present,
        source  => "puppet:///modules/buildbot/Makefile",
        require => File['/opt/buildbot'],
    }

    exec { "make-buildbot-virtualenv":
        command => "virtualenv --system-site-packages /opt/buildbot",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/bin/pip",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => File["/opt/buildbot"],
    }

}
