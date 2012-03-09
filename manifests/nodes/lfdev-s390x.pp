node 'etpglr3.dal-ebis.ihost.com' {

    include user::lfadmin, user::licquia, user::stewb, user::mats

    include sudo

    include puppet

    include buildbot::slavechroot

}
