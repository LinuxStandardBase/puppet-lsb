class mariadb::server {

    include mariadb

    package { 'mariadb-server':
        ensure => present,
    }

    service { 'mariadb':
        enable  => true,
        require => Package['mariadb-server'],
    }

}
