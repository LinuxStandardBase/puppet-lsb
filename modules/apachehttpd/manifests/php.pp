class apachehttpd::php {

    package {
        'apache2-mod_php5': ensure => present;
    }

    file { '/etc/php5/apache2/php.ini':
        source  => [ "puppet:///modules/apachehttpd/files/php.ini/$fqdn",
                     "puppet:///modules/apachehttpd/files/php.ini/default-opensuse13.1" ],
        require => Package['apache2-mod_php5'],
    }

}
