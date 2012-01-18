class apachehttpd::vhosts inherits apachehttpd {

    file { '/etc/apache2/vhosts.d':
        ensure => directory,
        source => "puppet:///modules/apachehttpd/vhosts.d/$fqdn",
        recurse => true,
        recurselimit => 1,
        links => follow,
        purge => true,
        require => Package['apache2'],
    }

}
