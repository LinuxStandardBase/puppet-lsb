node 'vm3.linuxbase.org' {

    include user::lfadmin, user::licquia, user::mats

    include ntp

    include sudo

    include ldap

    include puppet

    include mail::linuxbase

    include apachehttpd, apachehttpd::certbot

    include apachehttpd::qa

    include php

    include ftp

    include alien

    include mariadb::server

}
