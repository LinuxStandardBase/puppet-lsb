node 'lsb2.linux-foundation.org' {

    include user::lfadmin, user::licquia, user::mats

    include ntp

    include sudo

    include puppet::server

    include mail::linuxbase

    include apachehttpd, apachehttpd::vhosts, apachehttpd::betaspecs,
            apachehttpd::modules, apachehttpd::ssl

    include php

    include ftp

}
