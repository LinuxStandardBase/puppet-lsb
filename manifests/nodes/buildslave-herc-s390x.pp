# 64-bit s390x build slave on Hercules.
node 'lsb-k-b-s390x.lsbtest.net' {

    include sudo

    include puppet

    include ntp

    include buildbot::slave

}
