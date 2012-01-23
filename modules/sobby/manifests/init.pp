class sobby {

    package { sobby: ensure => present }

    file { "/etc/sobby.conf":
        source => "puppet:///modules/sobby/sobby.conf",
    }

    file { "/etc/init.d/sobby":
        source => "puppet:///modules/sobby/sobby.init",
        mode   => 0755,
    }

    service { "sobby":
        #ensure     => running,
        hasrestart => false,
        hasstatus  => false,
    }

}
