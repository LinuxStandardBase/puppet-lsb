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
        require      => Package["$apachehttpd::pkgname"],
        notify       => Service["$apachehttpd::pkgname"],
    }

    file { '/srv/www/vhosts':
        ensure  => directory,
        require => File['/srv/www'],
    }

}
