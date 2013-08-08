node 'lfdev-test-power64.osuosl.org' {

    include user::lfadmin, user::licquia, user::mats, user::mallachiev

    include sudo

    include puppet

}
