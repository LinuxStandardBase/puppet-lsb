class mariadb::server {

    include mariadb

    package { "mariadb-server":
        ensure => present,
    }

}
