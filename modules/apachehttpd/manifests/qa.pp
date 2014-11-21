class apachehttpd::qa {

    file { '/usr/local/bin/run_url_checker':
        content => template('apachehttpd/run_url_checker.sh.erb'),
        mode   => 0755,
    }

    cron { 'regular-url-check':
        command => '/usr/local/bin/run_url_checker',
        user    => root,
        hour    => 4,
        minute  => 0,
    }

}

