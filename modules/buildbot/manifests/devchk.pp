# This class implements a build slave for devchk.  Such build slaves
# test the LSB against native environments, so there should be a number
# of them, and they should be diverse--different distros and architectures.

class buildbot::devchk inherits buildbot::slave {

    $masteruser = "$operatingsystem-$operatingsystemrelease-$architecture" ? {
        /^Fedora-16-i386$/   => 'devchk-fedora-x86',
        /^Fedora-16-x86_64$/ => 'devchk-fedora-x86_64',
        default              => $buildbotpw::masteruser,
    }

    $masterpw = "$operatingsystem-$operatingsystemrelease-$architecture" ? {
        /^Fedora-16-i386$/   => $buildbotpw::x86fedora,
        /^Fedora-16-x86_64$/ => $buildbotpw::x64fedora,
        default              => $buildbotpw::masterpw,
    }

    package { $buildbot::slavepkgs::devchklist: ensure => present }

    Exec["make-slave"] {
        command => "/opt/buildbot/bin/buildslave create-slave --umask=022 /opt/buildbot/lsb-slave vm1.linuxbase.org:9989 $masteruser $masterpw",
    }

}
