# Test VM on Russ Herrold's network.
node 'vm049244134.pmman.net' {

    include user::licquia, user::stewb

    include sudo

    include puppet

    include buildbot::slave

}
