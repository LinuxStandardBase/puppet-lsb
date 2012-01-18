class httpd::vhosts inherits httpd {

    file { '/etc/apache2/vhosts.d':
        ensure => directory,
        source => "puppet:///modules/httpd/vhosts.d/$fqdn",
        recurse => true,
        recurselimit => 1,
        links => follow,
        purge => true,
        require => Package['httpd'],
    }

}
