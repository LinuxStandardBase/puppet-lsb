# Test VM on Jeff's home network.
node 'virtpc-sles11-amd64.internal.licquia.org' {

    include sudo

    include puppet

    include buildbot::slave

}
