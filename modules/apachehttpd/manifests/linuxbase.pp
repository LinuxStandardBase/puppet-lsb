class apachehttpd::linuxbase {

    include apachehttpd

    include apachehttpd::vhosts

    include apachehttpd::betaspecs

    file { '/srv/www/vhosts/linuxbase.org':
        ensure  => directory,
        require => File['/srv/www/vhosts'],
    }

    file { '/srv/www/vhosts/linuxbase.org/freenode.txt':
        source  => "puppet:///modules/apachehttpd/content/default/freenode.txt",
        require => File['/srv/www/vhosts/linuxbase.org'],
    }

    file { '/srv/www/vhosts/linuxbase.org/robots.txt':
        source  => "puppet:///modules/apachehttpd/content/default/robots.txt",
        require => File['/srv/www/vhosts/linuxbase.org'],
    }

    file { '/srv/www/vhosts/linuxbase.org/maintenance.html':
        source  => "puppet:///modules/apachehttpd/content/default/maintenance.html",
        require => File['/srv/www/vhosts/linuxbase.org'],
    }

}
