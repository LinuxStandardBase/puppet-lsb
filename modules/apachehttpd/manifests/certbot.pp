class apachehttpd::certbot {

    include miscpkgs::wget

    exec { "get-certbot-auto":
        command => "/usr/bin/wget -O /usr/local/sbin/certbot-auto https://dl.eff.org/certbot-auto && chmod +x /usr/local/sbin/certbot-auto",
        creates => "/usr/local/sbin/certbot-auto",
        require => Package["wget"],
    }

    cron { "refresh-certbot":
        command => "/usr/local/sbin/certbot-auto renew -n --quiet",
        user    => "root",
        hour    => 15,
        minute  => 38,
        weekday => 4,
    }

}
