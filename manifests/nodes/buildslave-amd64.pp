# Build slave VM on Jeff's home network.
node 'buildslave-amd64.internal.licquia.org' {

    include sudo

    include puppet

    #include buildbot::slave

}
