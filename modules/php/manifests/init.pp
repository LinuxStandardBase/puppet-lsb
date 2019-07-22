class php {

    $osdefault = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11/       => 'default-sles11',
        /^OpenSuSE-13/   => 'default-opensuse',
        /^CentOS-7/      => 'default-rhel7',
    }

    case $operatingsystem {

        /^(SLES|OpenSuSE)$/: {
            package {
                'php5': ensure => installed;
                'apache2-mod_php5': ensure => installed;
                'php5-ldap': ensure => installed;
                'php5-mysql': ensure => installed;
                'php5-curl': ensure => installed;
            }

            file { '/etc/php5/apache2/php.ini':
                source  => [ "puppet:///modules/php/php.ini/$fqdn",
                             "puppet:///modules/php/php.ini/$osdefault" ],
                require => Package['apache2-mod_php5'],
            }
        }

        /^(CentOS|RHEL)$/: {
            package {
                'php': ensure => installed;
                'php-ldap': ensure => installed;
                'php-mysql': ensure => installed;
            }

            file { '/etc/php.ini':
                source  => [ "puppet:///modules/php/php.ini/$fqdn",
                             "puppet:///modules/php/php.ini/$osdefault" ],
                require => Package['php'],
            }
        }
    }
}
