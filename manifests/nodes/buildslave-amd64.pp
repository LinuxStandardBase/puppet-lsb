# Build slave VM on Jeff's home network.
node 'vm178231020.pmman.net' {

    include ntp

    include sudo

    include puppet

    include buildbot::slave

}
