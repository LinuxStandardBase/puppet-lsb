class buildbot {

    include user::buildbot

    $buildbotversion = '0.8.6p1'
    $twistedversion = '8.2.0'

    $pythonversion = "$operatingsystem-$operatingsystemrelease" ? {
        /^CentOS-5/   => '2.4',
        /^Fedora-16$/ => '2.7',
        default       => '2.6',
    }

}
