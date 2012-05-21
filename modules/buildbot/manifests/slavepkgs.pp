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
        /^Fedora$/ => ['redhat-lsb', 'qt'],
        /^CentOS$/ => ['redhat-lsb', 'qt'],
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

    # Java package, needed by OLVER.  On ia64, SuSE does not ship a
    # decent JRE, so you have to download the ia64 JRE directly from
    # Oracle.
    $javapkg = "$operatingsystem-$architecture" ? {
        /^SLES-x86_64$/ => 'java-1_6_0-ibm',
        /^SLES-s390x$/  => 'java-1_6_0-ibm',
        /^SLES-ppc64$/  => 'java-1_6_0-ibm',
        /^SLES-ia64$/   => 'jre',
        /^CentOS/       => 'java-1.6.0-openjdk',
        default         => 'openjdk',
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

    # expat - needed for old builds of libbat/appbat
    $expatdevelpkg = $operatingsystem ? {
        /^SLES/   => 'libexpat-devel',
        /^CentOS/ => 'expat-devel',
        default   => 'libexpat-dev',
    }

    # runtime-test for 4.0 still uses expect
    $expectpkg = $operatingsystem ? {
        /^SLES/   => 'expect',
        default   => 'expect',
    }

    # devchk needs
    $qt4pkg = $operatingsystem ? {
        /^SLES/   => 'libqt4-devel',
        default   => 'libqt4-devel',
    }
    $alsapkg = $operatingsystem ? {
        /^SLES/   => 'alsa-devel',
        default   => 'alsa-devel',
    }
    $atkpkg = $operatingsystem ? {
        /^SLES/   => 'atk-devel',
        default   => 'atk-devel',
    }
    $cairopkg = $operatingsystem ? {
        /^SLES/   => 'cairo-devel',
        default   => 'cairo-devel',
    }
    $cupspkg = $operatingsystem ? {
        /^SLES/   => 'cups-devel',
        default   => 'cups-devel',
    }
    $fontconfigpkg = $operatingsystem ? {
        /^SLES/   => 'fontconfig-devel',
        default   => 'fontconfig-devel',
    }
    $freetypepkg = $operatingsystem ? {
        /^SLES/   => 'freetype2-devel',
        default   => 'freetype2-devel',
    }
    $glibpkg = $operatingsystem ? {
        /^SLES/   => 'glib2-devel',
        default   => 'glib2-devel',
    }
    $gtkpkg = $operatingsystem ? {
        /^SLES/   => 'gtk2-devel',
        default   => 'gtk2-devel',
    }
    $jpegpkg = $operatingsystem ? {
        /^SLES/   => 'libjpeg-devel',
        default   => 'libjpeg-devel',
    }
    $GLpkg = $operatingsystem ? {
        /^SLES/   => 'MesaGLw-devel',
        default   => 'Mesa-devel',
    }
    $xmlpkg = $operatingsystem ? {
        /^SLES/   => 'xml2-devel',
        default   => 'xml2-devel',
    }
    $nsprpkg = $operatingsystem ? {
        /^SLES/   => 'mozilla-nspr-devel',
        default   => 'nspr-devel',
    }
    $nsspkg = $operatingsystem ? {
        /^SLES/   => 'mozilla-nss-devel',
        default   => 'nss-devel',
    }
    $pangopkg = $operatingsystem ? {
        /^SLES/   => 'pango-devel',
        default   => 'pango-devel',
    }
    $pngpkg = $operatingsystem ? {
        /^SLES/   => 'libpng-devel',
        default   => 'libpng-devel',
    }
    $zlibpkg = $operatingsystem ? {
        /^SLES/   => 'zlib-devel',
        default   => 'zlib-devel',
    }
    $xprotopkg = $operatingsystem ? {
        /^SLES/   => 'xorg-x11-proto-devel',
        default   => 'xorg-x11-proto-devel',
    }
    $xrenderpkg = $operatingsystem ? {
        /^SLES/   => 'xorg-x11-libXrender-devel',
        default   => 'xorg-x11-libXrender-devel',
    }
    $devchklist = [ "$qt4pkg", "$alsapkg", "$atkpkg", "$cairopkg",
                    "$cupspkg", "$fontconfigpkg", "$freetypepkg",
                    "$glibpkg", "$gtkpkg", "$jpegpkg", "$GLpkg",
                    "$xmlpkg", "$nsprpkg", "$nsspkg", "$pangopkg",
                    "$pngpkg", "$zlibpkg", "$xprotopkg", $xrenderpkg" ]
    # end devchk
    
    # command for forcing the small-word environment
    $smallwordpkg = $architecture ? {
        's390x' => 's390-32',
        'ppc64' => 'powerpc32',
        default => '',
    }

    # Most packages needed for a typical slave; see the definitions
    # above for $ucs2anypkg and $xdevelpkg for the interesting ones.
    $pkglist = [ "$lsbpkg", "$rpmpkg", "$gpluspluspkg", "$pkgconfigpkg",
                 "$javapkg", 'autoconf', 'automake', 'libtool', 'bison',
                 'flex', "$xgettextpkg", 'rsync', "$bdftopcfpkg",
                 "$intltoolpkg", "$glibdevelpkg", "$pamdevelpkg",
                 "$expectpkg", "$expatdevelpkg", 'perl', 
                 'ncurses-devel', "$devchklist" ]

}
