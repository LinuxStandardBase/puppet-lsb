node 'linfnd1.lf-dev.marist.edu' {

    include sudo

    include puppet

    include buildbot::slave

}
