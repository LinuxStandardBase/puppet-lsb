# Test VM on Russ Herrold's network.
node 'devchk-fedora-x86-2.lsbtest.net' {

    include user::licquia

    include sudo

    include puppet

    include buildbot::devchk

}
