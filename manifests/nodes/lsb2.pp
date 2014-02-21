node 'lsb2.linux-foundation.org' {

    include user::lfadmin, user::licquia, user::mats

    include ntp

    include sudo

}
