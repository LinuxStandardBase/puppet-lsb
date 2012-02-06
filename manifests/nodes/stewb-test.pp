# Test VM on Stew's network.
node 'sles11-32-puppet.e-artisan.org' {

    include user::licquia, user::stewb

    include sudo

    include puppet

    include buildbot::slave

}
