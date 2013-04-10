node 'lfdev-test-power64.osuosl.org' {

    include user::lfadmin, user::licquia, user::mats

    include sudo

    include puppet

}
