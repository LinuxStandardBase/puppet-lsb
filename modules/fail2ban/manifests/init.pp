class fail2ban {

    package { 'fail2ban':
        ensure => present
    }

    package { 'jwhois':
        ensure => present
    }

    file { '/etc/fail2ban/jail.d/buildslave':
        source  => 'puppet:///modules/fail2ban/buildslave',
        require => Package['fail2ban'],
        notify  => Service['fail2ban'],
    }

    service { "fail2ban":
        ensure => running,
        require => [ Package['fail2ban'], File['/etc/fail2ban/jail.d/buildslave'] ].
    }

}
