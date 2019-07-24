class apachehttpd::vhosts {

    include apachehttpd

    include logrotate::web

    file { 'vhosts-d-dir':
        path         => "$apachehttpd::configpath/vhosts.d",
        ensure       => directory,
        source       => "puppet:///modules/apachehttpd/vhosts.d/$fqdn",
        recurse      => true,
        recurselimit => 1,
        links        => follow,
        purge        => true,
        require      => Package['apache2'],
        notify       => Service['apache2'],
    }

    file { '/srv/www/vhosts':
        ensure  => directory,
        require => File['/srv/www'],
    }

}
