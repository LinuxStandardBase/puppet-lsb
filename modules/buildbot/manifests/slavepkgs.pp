class buildbot::slavepkgs {

    # First, some variable-name packages.

    # xts5 is no longer a pure LSB build, needs at least libXi, Xext, Xtst, Xt
    # probably more, the SLES package pulls in a bunch
    $xdevelpkg = $operatingsystem ? {
        /^Fedora$/ => ['libXi-devel', 'libXext-devel', 'libXtst-devel', 'libXt-devel'],
        /^CentOS$/ => ['libXi-devel', 'libXext-devel', 'libXtst-devel', 'libXt-devel'],
        /^SLES/ => 'xorg-x11-devel',
        default => 'libxorg-x11-devel',
    }

    # this one for xts5 and lsb-xvfb
    $bdftopcfpkg = $operatingsystem ? {
        /^Fedora$/ => 'xorg-x11-font-utils',
        /^CentOS$/ => 'xorg-x11-font-utils',
        /^SLES/ => 'xorg-x11',
        default => 'bdftopcf',
    }

    # for lsb-xvfb
    # NOTE: on Red Hat-based systems, this is the same as $bdftopcfpkg,
    # so don't include it 
    $ucs2anypkg = $operatingsystem ? {
        /^Fedora$/ => 'xorg-x11-font-utils',
        /^CentOS$/ => 'xorg-x11-font-utils',
        /^SLES/ => 'xorg-x11-fonts-devel',
        default => 'x11-font-util',
    }

    $lsbpkg = $operatingsystem ? {
        /^Fedora$/ => 'redhat-lsb',
        /^CentOS$/ => 'redhat-lsb',
        default    => 'lsb',
    }

    $rpmpkg = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-.+$/     => 'rpm',
        /^OpenSuSE-.+$/ => 'rpm',
        default         => 'rpm-build',
    }

    $gpluspluspkg = $operatingsystem ? {
        default      => 'gcc-c++',
    }

    $javapkg = "$operatingsystem-$architecture" ? {
        /^SLES-x86_64$/ => 'java-1_6_0-ibm',
        /^SLES-s390x$/  => 'java-1_6_0-ibm',
        /^SLES-ppc64$/  => 'java-1_6_0-ibm',
        /^SLES-ia64$/   => 'java-1_4_2-ibm',
        /^CentOS/ => 'java-1.6.0-openjdk',
        default   => 'openjdk',
    }

    $pkgconfigpkg = $operatingsystem ? {
        /^SLES/ => 'pkg-config',
        default => 'pkgconfig',
    }

    $xgettextpkg = $operatingsystem ? {
        /^SLES/ => 'gettext-tools',
        default => 'gettext',
    }

    # for appbat
    $intltoolpkg = $operatingsystem ? {
        /^SLES/ => 'intltool',
        default => 'intltool',
    }

    # for appbat - need glib-genmarshal
    $glibdevelpkg = $operatingsystem ? {
        /^SLES/ => 'glib2-devel',
        default => 'glib2-devel',
    }

    # for appbat - samba needs pam_modules.h
    $pamdevelpkg = $operatingsystem ? {
        /^SLES/ => 'pam-devel',
        default => 'pam-devel',
    }

    # runtime-test for 4.0 still uses expect
    $expectpkg = $operatingsystem ? {
        /^SLES/   => 'expect',
        default   => 'expect',
    }

    # Most packages needed for a typical slave; see the definitions
    # above for $ucs2anypkg and $xdevelpkg for the interesting ones.
    $pkglist = [ "$lsbpkg", "$rpmpkg", "$gpluspluspkg", "$pkgconfigpkg",
                 "$javapkg", 'autoconf', 'automake', 'libtool', 'bison',
                 'flex', "$xgettextpkg", 'rsync', "$bdftopcfpkg",
                 "$intltoolpkg", "$glibdevelpkg", "$pamdevelpkg",
                 "$expectpkg", 'perl' ]

}
