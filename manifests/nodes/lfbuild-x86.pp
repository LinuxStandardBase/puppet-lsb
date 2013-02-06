# x86 build slave on Russ Herrold's PMMAN service
node 'vm178231187.pmman.net' {

    include user::licquia, user::stewb

    include sudo

    include puppet

    include buildbot::slave

}
