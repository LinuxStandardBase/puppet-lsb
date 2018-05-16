node 'lsb-1.openstacklocal' {

    include user::lfadmin, user::licquia, user::mats

    include ntp

    include sudo

    include puppet

    include buildbot::slave

}
