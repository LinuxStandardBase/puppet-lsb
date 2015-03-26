class apachehttpd::files {

    include apachehttpd

    include apachehttpd::vhosts

    file { '/data/ftp/incoming':
        ensure => directory,
        mode   => 0700,
        owner  => ftp,
    }

}

