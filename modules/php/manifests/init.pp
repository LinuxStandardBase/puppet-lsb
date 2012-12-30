class php {

    $osdefault = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11/ => 'default-sles11',
    }

    case $operatingsystem {

        /^SLES$/: {
            package {
                'php5': ensure => installed;
                'apache2-mod_php5': ensure => installed;
                'php5-ldap': ensure => installed;
                'php5-mysql': ensure => installed;
            }

            file { '/etc/php5/apache2/php.ini':
                source  => [ "puppet:///modules/php/php.ini/$fqdn",
                             "puppet:///modules/php/php.ini/$osdefault" ],
                require => Package['apache2-mod_php5'],
            }
        }
    }
}
