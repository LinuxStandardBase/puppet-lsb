node 'lfdev-build-power64.osuosl.org' {

    include user::lfadmin, user::licquia, user::mats

    include sudo

    include puppet

    include buildbot::slave

}
