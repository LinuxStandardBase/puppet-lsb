# This class implements a build slave for devchk.  Such build slaves
# test the LSB against native environments, so there should be a number
# of them, and they should be diverse--different distros and architectures.

class buildbot::devchk inherits buildbot::slave {

    include buildbotpw

    $masteruser = "$operatingsystem-$operatingsystemrelease-$architecture" ? {
        /^Fedora-16-i386$/   => 'devchk-fedora-x86',
        /^Fedora-16-x86_64$/ => 'devchk-fedora-x86_64',
        default              => 'unknown',
    }

    $masterpw = "$operatingsystem-$operatingsystemrelease-$architecture" ? {
        /^Fedora-16-i386$/   => $buildbotpw::x86fedora,
        /^Fedora-16-x86_64$/ => $buildbotpw::x64fedora,
        default              => 'unknown',
    }

    package { $buildbot::slavepkgs::devchklist: ensure => present }

    # We override some slave build commands in order to substitute
    # the proper username/password combinations.  This is made harder
    # because of how Puppet handles variables.  If we change these
    # commands, we need to change them here and in buildbot::slave.

    Exec["make-slave"] {
        command => "/opt/buildbot/bin/buildslave create-slave --umask=022 /opt/buildbot/lsb-slave ${buildbotmaster}:${buildbotport} $masteruser $masterpw",
    }

}
