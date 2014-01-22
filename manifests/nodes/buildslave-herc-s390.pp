# 31-bit s390 build slave on Hercules.
node 'lsb-k-b-s390.lsbtest.net' {

    include sudo

    include puppet

    include buildbot::slave

}
