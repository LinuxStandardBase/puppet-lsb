class sudo {

    include user::lfadmin

    $osdefault = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^(CentOS|RedHat)-5\.[0-9]+$/       => 'default-el5',
        /^(CentOS|RedHat)-6(\.[0-9]+)?$/    => 'default-fedora',
        /^Fedora-1[5-9]$/                   => 'default-fedora',
        /^SLES-11\.?[0-9]*$/                => 'default-sles11',
        /^OpenSuSE/                         => 'default-opensuse',
    }

    package { sudo: ensure => latest }

    file { "/etc/sudoers":
        owner   => root,
        group   => root,
        mode    => 0440,
        source  => [ "puppet:///modules/sudo/sudoers/$clientcert",
                     "puppet:///modules/sudo/sudoers/$osdefault" ],
        links   => follow,
        require => [ Package["sudo"], User['lfadmin'] ]
    }

}
