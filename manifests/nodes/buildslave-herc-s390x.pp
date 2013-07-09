# Backup 64-bit s390 build slave on Hercules.
node 'buildslave-s390x.internal.licquia.org' {

    include sudo

    include puppet

    include buildbot::slave

}
