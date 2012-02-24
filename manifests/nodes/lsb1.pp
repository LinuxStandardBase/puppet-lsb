node 'lsb1.linux-foundation.org' {

    include user::lfadmin, user::licquia, user::stewb, user::mats

    include sudo

    include puppet::server

    include apachehttpd, apachehttpd::vhosts, apachehttpd::betaspecs,
            apachehttpd::modules

    include ftp

    include mail::linuxbase

    include buildbot::master

}
