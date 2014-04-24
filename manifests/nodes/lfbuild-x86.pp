# x86 build slave on Russ Herrold's PMMAN service
node 'lfbuild-x86-2.lsbtest.net' {

    include user::licquia, user::stewb

    include sudo

    include puppet

    include buildbot::slave

}
