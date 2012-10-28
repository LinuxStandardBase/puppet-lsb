class puppet {

    $osdefault = "$operatingsystem-$operatingsystem" ? {
        /^SLES-11/ => 'default-sles11',
        /^Debian/  => 'default-debian',
        default    => 'default-sles11',
    }

    $puppetversion = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11\.1$/  => '2.6.17-0.3.1',
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

    if $operatingsystem == "SLES" {
        file { '/etc/sysconfig/puppet':
            source => [ "puppet:///modules/puppet/sysconfig/$fqdn",
                        "puppet:///modules/puppet/sysconfig/$osdefault" ],
        }
    }

    if $operatingsystem == "Debian" {
        file { '/etc/default/puppet':
            source => [ "puppet:///modules/puppet/etcdefault/$fqdn",
                        "puppet:///modules/puppet/etcdefault/$osdefault" ],
        }
    }

    service { 'puppet':
        enable      => true,
        require     => Package['puppet'],
    }

    package { 'facter': ensure => $facterversion; }
    package { 'puppet': ensure => $puppetversion; }

}
