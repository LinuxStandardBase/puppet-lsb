class ntp {

    $ntpservice = "$operatingsystem-$operatingsystemrelease" ? {
        /^CentOS-7/   => 'ntpd',
        default       => 'ntp',
    }

    package { 'ntp': ensure => present }

    file { '/etc/ntp.conf':
        source  => 'puppet:///modules/ntp/ntp.conf',
        require => Package['ntp'],
        notify  => Service["$ntpservice"],
    }

    service { "$ntpservice":
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        require    => [ Package['ntp'], File['/etc/ntp.conf'] ],
    }

}
