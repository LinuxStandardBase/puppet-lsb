node 'lsb1.linux-foundation.org' {

    include user::lfadmin, user::licquia, user::stewb

    include sudo

    include puppet::server

    include apachehttpd, apachehttpd::vhosts, apachehttpd::betaspecs

    include ftp

    include mail::postfix

    include buildbot::master

    include buildbot::slave

}
