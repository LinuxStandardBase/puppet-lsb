class sobby {

    package { sobby: ensure => present }

    file { "/etc/sobby.conf":
        source => "puppet:///modules/sobby/sobby.conf",
        notify => Service['sobby'],
    }

    file { "/etc/init.d/sobby":
        source => "puppet:///modules/sobby/sobby.init",
        mode   => 0755,
        notify => Service['sobby'],
    }

    service { "sobby":
        ensure     => running,
        hasrestart => false,
        hasstatus  => false,
    }

}
