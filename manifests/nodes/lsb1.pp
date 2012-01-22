node 'lsb1.linux-foundation.org' {

    include puppet::server

    include apachehttpd, apachehttpd::vhosts, apachehttpd::betaspecs

    include ftp

    include mail::postfix

}
