# Backup 31-bit s390 build slave on Hercules.
node 'lsb-x-s390.lsbtest.net' {

    include sudo

    include puppet

    include buildbot::slave

}
