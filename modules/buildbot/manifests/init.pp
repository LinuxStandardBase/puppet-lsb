class buildbot {

    include python::virtualenv

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
        notify => Exec['setup-buildbot'],
    }

    file { "/opt/buildbot/Makefile":
        ensure  => present,
        source  => "puppet:///modules/buildbot/Makefile",
        require => File['/opt/buildbot'],
    }

}
