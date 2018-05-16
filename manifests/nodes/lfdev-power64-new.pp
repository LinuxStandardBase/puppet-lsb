node 'lsb-2.openstacklocal' {

    include user::lfadmin, user::licquia, user::mats

    include ntp

    include sudo

    include puppet

    include buildbot::slave

}
