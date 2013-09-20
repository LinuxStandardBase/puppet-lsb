node 'lfdev-test-power64.osuosl.org' {

    include user::lfadmin, user::licquia, user::mats, user::mallachiev, user::herrold

    include sudo

    include puppet

}
