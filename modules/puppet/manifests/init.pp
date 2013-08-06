class puppet {

    $osdefault = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11/ => 'default-sles11',
        /^Debian/  => 'default-debian',
        default    => 'default-sles11',
    }

    $puppetversion = "${operatingsystem}-${operatingsystemrelease}-${architecture}" ? {
        /^SLES-11\..-s390x$/ => '2.6.17-0.3.1',
        /^SLES-11\.1-.*$/    => '2.7.6-9.1',
        /^SLES-11\.2-.*$/    => '3.1.1-1.7',
        default              => present,
    }

    $puppetmasterversion = '3.1.1-1.7'

    $facterversion = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11\.1$/  => '1.5.2-1.20',
        /^SLES-11\.2$/  => '1.6.18-1.1',
        default         => present,
    }

    $puppetservice = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^Fedora-/ => 'puppetagent',
        default    => 'puppet',
    }

    file { 'puppet.conf':
        name => '/etc/puppet/puppet.conf',
        source => 'puppet:///modules/puppet/puppet.conf',
        owner => 'root',
        group => 'root',
        mode  => 644,
    }

    if $operatingsystem == "SLES" {
        file { '/etc/zypp/repos.d/home_lserepo.repo':
            source => 'puppet:///modules/puppet/home_lserepo.repo',
            notify => Exec['refresh-zypper-keys-for-puppet'],
            before => Package['puppet'],
        }

        file { '/etc/zypp/repos.d/systemsmanagement_puppet.repo':
            source => 'puppet:///modules/puppet/systemsmanagement_puppet.repo',
            notify => Exec['refresh-zypper-keys-for-puppet'],
            before => Package['puppet'],
        }

        exec { 'refresh-zypper-keys-for-puppet':
            command     => 'zypper --gpg-auto-import-keys refresh',
            path        => [ '/usr/sbin', '/usr/bin', '/bin', '/sbin' ],
            refreshonly => true,
            logoutput   => true,
        }

        file { '/etc/sysconfig/puppet':
            source  => [ "puppet:///modules/puppet/sysconfig/$fqdn",
                         "puppet:///modules/puppet/sysconfig/$osdefault" ],
            require => Package['puppet'],
        }

        # For SLES 11 systems that have the vendor puppet package,
        # zypper will prevent upgrading to a newer package due to
        # the vendor change.  So, in order to make that happen, we
        # temporarily ignore vendor changes.

        if $::puppetversion == "2.6.17" {

            file { '/tmp/zypp.conf':
                content => "
[main]
solver.allowVendorChange = true
",
            }

            exec { 'update-puppet-with-vendor-change':
                command => "zypper --config /tmp/zypp.conf --quiet install -y --force-resolution puppet-$puppetversion",
                path    => [ '/usr/sbin', '/usr/bin', '/bin', '/sbin' ],
                require => File['/tmp/zypp.conf'],
                before  => Package['puppet'],
            }

        }
    }

    if $operatingsystem == "Debian" {
        file { '/etc/default/puppet':
            source  => [ "puppet:///modules/puppet/etcdefault/$fqdn",
                         "puppet:///modules/puppet/etcdefault/$osdefault" ],
            require => Package['puppet'],
        }
    }

    service { $puppetservice:
        enable      => true,
        require     => Package['puppet'],
    }

    package { 'facter': ensure => $facterversion; }
    package { 'puppet': ensure => $puppetversion; }

}
