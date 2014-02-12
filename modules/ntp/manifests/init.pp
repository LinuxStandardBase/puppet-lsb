class ntp {

    package { 'ntp': ensure => present }

    file { '/etc/ntp.conf':
        source  => 'puppet:///modules/ntp/ntp.conf',
        require => Package['ntp'],
        notify  => Service['ntp'],
    }

    service { 'ntp':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        require    => [ Package['ntp'], File['/etc/ntp.conf'] ],
    }

}
