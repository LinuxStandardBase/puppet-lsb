# x86_64 build slave
node 'vm049244208.pmman.net' {

    include sudo

    include puppet

    include buildbot::slave

}
