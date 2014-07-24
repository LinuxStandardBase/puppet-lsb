node 'lsb1.linux-foundation.org' {

    include user::lfadmin, user::licquia, user::stewb, user::mats, user::herrold

    include ntp

    include sudo

    include puppet

    include apachehttpd, apachehttpd::vhosts, apachehttpd::betaspecs,
            apachehttpd::ssl, apachehttpd::linuxbase

    include php

    include ftp

    include mail::postfix

}
