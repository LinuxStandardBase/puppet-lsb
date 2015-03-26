node 'lsb2.linux-foundation.org' {

    include user::lfadmin, user::licquia, user::mats

    include ntp

    include sudo

    include ldap

    include puppet::server

    include mail::linuxbase

    include apachehttpd, apachehttpd::vhosts, apachehttpd::betaspecs,
            apachehttpd::modules, apachehttpd::ssl, apachehttpd::linuxbase,
            apachehttpd::files

    include apachehttpd::qa

    include php

    include ftp

    include supybot

    include alien

    include buildbot::master

}
