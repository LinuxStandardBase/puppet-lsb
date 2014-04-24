# Test VM on Russ Herrold's network.
node 'devchk-fedora-x8664-2.lsbtest.net' {

    include user::licquia

    include sudo

    include puppet

    include buildbot::devchk

}
