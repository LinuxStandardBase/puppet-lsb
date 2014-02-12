node 'lfdev-test-power64.osuosl.org' {

    include user::lfadmin, user::licquia, user::mats, user::mallachiev, user::herrold

    include ntp

    include sudo

    include puppet

}
