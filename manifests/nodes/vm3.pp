node 'vm3.linuxbase.org' {

    include puppet

    include user::lfadmin, user::licquia, user::mats

    include ntp

    include sudo

    include ldap

    include alien

    include mariadb::server

}
