# Test VM on Russ Herrold's network.
node 'vm178231168.pmman.net' {

    include user::licquia

    include sudo

    include puppet

    include buildbot::devchk

}
