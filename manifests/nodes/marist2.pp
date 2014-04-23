node 'linfnd2.lf-dev.marist.edu' {

    include sudo

    include puppet

    include buildbot::slave

}
