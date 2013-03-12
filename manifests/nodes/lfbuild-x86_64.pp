# x86_64 build slave, currently on Jeff's home network
node 'virtpc-opensuse-amd64.internal.licquia.org' {

    include sudo

    include puppet

    #include buildbot::slave

}
