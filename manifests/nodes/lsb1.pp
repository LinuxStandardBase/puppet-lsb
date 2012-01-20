node 'lsb1.linux-foundation.org' {

    include apachehttpd, apachehttpd::vhosts, apachehttpd::betaspecs

    include ftp

}
