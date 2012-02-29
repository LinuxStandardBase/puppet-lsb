node 'lfdev-ia64.linux-foundation.org' {

    include user::lfadmin, user::licquia, user::stewb, user::mats

    include sudo

    include puppet

    include buildbot::slave

}
