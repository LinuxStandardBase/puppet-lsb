class sudo {

    $osdefault = "$operatingsystem-$operatingsystemrelease" ? {
        /^(CentOS|RedHat)-5\.[0-9]+$/       => 'default-el5',
        /^(CentOS|RedHat)-6(\.[0-9]+)?$/    => 'default-el6',
        /^Fedora-1[5-9]$/                   => 'default-fedora',
        /^SLES-11\.?[0-9]*$/                => 'default-sles11',
    }

    package { sudo: ensure => latest }

    file { "/etc/sudoers":
        owner   => root,
        group   => root,
        mode    => 0440,
        source  => [ "puppet:///modules/sudo/sudoers/$fqdn",
                     "puppet:///modules/sudo/sudoers/default-$osdefault" ],
        require => Package["sudo"],
    }

}
