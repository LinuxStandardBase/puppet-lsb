class puppet {

    $puppetversion = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11\.1$/  => '2.6.12-0.6.1',
        default         => present,
    }
    $facterversion = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11\.1$/  => '1.5.2-1.20',
        default         => present,
    }

    file { 'puppet.conf':
        name => '/etc/puppet/puppet.conf',
        source => 'puppet:///modules/puppet/puppet.conf',
        owner => 'root',
        group => 'root',
        mode  => 644,
    }

    service { 'puppet':
        enable      => true,
        require     => Package['puppet'],
    }

    package { 'facter': ensure => $facterversion; }
    package { 'puppet': ensure => $puppetversion; }

}
