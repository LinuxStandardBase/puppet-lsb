class apachehttpd::download {

    include python::virtualenv

    include user::downloadapp

    exec { 'make-download-venv':
        command => "virtualenv /opt/download-app",
        creates => "/opt/download-app/bin/pip",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => Package['python-virtualenv'],
    }

    exec { 'install-download-app':
        command => "/opt/download-app/bin/pip install --upgrade git+https://github.com/LinuxStandardBase/download-app.git",
        require => Exec['make-download-venv'],
    }

    file { '/etc/systemd/system/downloadapp.service':
        ensure => present,
        source => "puppet:///modules/apachehttpd/downloadapp.service",
        notify => Service['downloadapp'],
    }

    service { 'downloadapp':
        ensure => running,
        require => [ User['downloadapp'],
                     Exec['install-download-app'],
                     File['/etc/systemd/system/downloadapp.service'] ],
    }

}
