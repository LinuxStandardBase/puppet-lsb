# Build slave VM on Jeff's home network.
node 'buildslave-amd64.internal.licquia.org' {

    include ntp

    include sudo

    include puppet

    include buildbot::slave

}
