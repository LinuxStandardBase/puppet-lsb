# Backup 64-bit s390 build slave on Hercules.
node 'lsb-x-b-s390x.lsbtest.net' {

    include sudo

    include puppet

    include ntp

    include buildbot::slave

}
