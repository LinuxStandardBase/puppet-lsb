# Backup 31-bit s390 build slave on Hercules.
node 'buildslave-s390.internal.licquia.org' {

    include sudo

    include puppet

    include buildbot::slave

}
