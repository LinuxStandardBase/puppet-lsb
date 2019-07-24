node 'vm3.linuxbase.org' {

    include user::lfadmin, user::licquia, user::mats

    include ntp

    include sudo

    include ldap

    include puppet

    include mail::linuxbase

    include apachehttpd, apachehttpd::vhosts, apachehttpd::betaspecs,
            apachehttpd::modules, apachehttpd::linuxbase, apachehttpd::certbot,
            apachehttpd::download

    include apachehttpd::qa

    include php

    include ftp

    include alien

    include mariadb::server

}
