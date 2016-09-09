class buildbot {

    include user::buildbot

    $buildbotversion = '0.8.7p1'
    $twistedversion = '9.0.0'

    $pythonversion = "$operatingsystem-$operatingsystemrelease" ? {
        /^CentOS-5/   => '2.4',
        default       => '2.7',
    }

}
