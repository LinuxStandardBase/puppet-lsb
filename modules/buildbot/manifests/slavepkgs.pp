class buildbot::slavepkgs {

    # How to add packages to LSB build slaves:

    # For easy packages, where there is a single package that provides
    # what you need, just add the package name to $pkglist at the bottom.
    # For slightly more complicated packages, create a variable that's
    # defined by a conditional based on OS name, and add that variable
    # to $pkglist.  If more than one package is needed (even if that's
    # for just one OS), create a new list here, and use the macro in
    # buildbot::slave to install the new list.  See $lsbpkg here and in
    # buildbot::slave to see an example of defining your own list.

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

    $rpmpkg = "${operatingsystem}-${operatingsystemrelease}" ? {
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
    $javapkg = "${operatingsystem}-${architecture}" ? {
        /^SLES-x86_64$/ => 'java-1_6_0-ibm',
        /^SLES-s390x$/  => 'java-1_6_0-ibm',
        /^SLES-ppc64$/  => 'java-1_6_0-ibm',
        /^SLES-ia64$/   => 'jre',
        /^CentOS/       => 'java-1.6.0-openjdk',
        /^Fedora/       => 'java-1.7.0-openjdk',
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
        /^Fedora/ => 'expat-devel',
        default   => 'libexpat-dev',
    }

    # runtime-test for 4.0 still uses expect
    $expectpkg = $operatingsystem ? {
        /^SLES/   => 'expect',
        default   => 'expect',
    }

    # Apparently, libbat needs the printproto stuff to be
    # installed.  This should be built and used as part of
    # the libbat build; need to investigate.
    $printprotopkg = $operatingsystem ? {
        /^SLES/   => 'xorg-x11-proto-devel',
        /^CentOS/ => 'libXp-devel',
        default   => 'libXp-devel',
    }

    # devchk needs
    $qt4pkg = $operatingsystem ? {
        /^SLES/   => 'libqt4-devel',
        /^CentOS/ => 'qt4-devel',
        /^Fedora/ => 'qt-devel',
        default   => 'libqt4-devel',
    }
    $alsapkg = $operatingsystem ? {
        /^SLES/   => 'alsa-devel',
        /^CentOS/ => 'alsa-lib-devel',
        /^Fedora/ => 'alsa-lib-devel',
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
        /^CentOS/ => 'freetype-devel',
        /^Fedora/ => 'freetype-devel',
        default   => 'freetype2-devel',
    }
    $gtkpkg = $operatingsystem ? {
        /^SLES/   => 'gtk2-devel',
        default   => 'gtk2-devel',
    }
    $jpegpkg = $operatingsystem ? {
        /^SLES/   => 'libjpeg-devel',
        /^Fedora/ => 'libjpeg-turbo-devel',
        default   => 'libjpeg-devel',
    }
    $GLpkg = $operatingsystem ? {
        /^SLES/   => 'Mesa-devel',
        /^CentOS/ => 'mesa-libGLU-devel',
        /^Fedora/ => 'mesa-libGLU-devel',
        default   => 'Mesa-devel',
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
    $xkbpkg = $operatingsystem ? {
        /^SLES/   => 'xorg-x11-libxkbfile-devel',
        /^CentOS/ => 'libxkbfile-devel',
        /^Fedora/ => 'libxkbfile-devel',
        default   => 'xorg-x11-libxkbfile-devel',
    }
    $xrenderpkg = $operatingsystem ? {
        /^SLES/   => 'xorg-x11-libXrender-devel',
        /^CentOS/ => 'libXrender-devel',
        /^Fedora/ => 'libXrender-devel',
        default   => 'xorg-x11-libXrender-devel',
    }
    $kernelpkg = $operatingsystem ? {
        /^SLES/   => 'linux-kernel-headers',
        /^CentOS/ => 'kernel-headers',
        /^Fedora/ => 'kernel-headers',
        default   => 'linux-kernel-headers',
    }
    $sanepkg = $operatingsystem ? {
        /^SLES/   => 'sane-backends',
        /^CentOS/ => 'sane-backends-devel',
        /^Fedora/ => 'sane-backends-devel',
        default   => 'libsane1-devel',
    }
    $tiffpkg = $operatingsystem ? {
        default => 'libtiff-devel',
    }
    $devchklist = [ "$qt4pkg", "$alsapkg", "$atkpkg", "$cairopkg",
                    "$cupspkg", "$fontconfigpkg", "$freetypepkg",
                    "$gtkpkg", "$jpegpkg", "$GLpkg",
                    'libxml2-devel', "$nsprpkg", "$nsspkg", "$pangopkg",
                    "$pngpkg", "$zlibpkg", "$xprotopkg", "$xrenderpkg",
                    "$kernelpkg", "$sanepkg", "$xkbpkg", 'libxslt-devel',
                    "$tiffpkg" ]
    # end devchk
    
    # command for forcing the small-word environment
    $smallwordpkg = $architecture ? {
        's390x' => 's390-32',
        'ppc64' => 'powerpc32',
        default => '',
    }

    # Most packages needed for a typical slave; see the definitions
    # above for $ucs2anypkg and $xdevelpkg for the interesting ones.
    $pkglist = [ "$rpmpkg", "$gpluspluspkg", "$pkgconfigpkg",
                 "$javapkg", 'autoconf', 'automake', 'libtool', 'bison',
                 'flex', "$xgettextpkg", 'rsync', "$bdftopcfpkg",
                 "$intltoolpkg", "$glibdevelpkg", "$pamdevelpkg",
                 "$expectpkg", "$expatdevelpkg", 'perl', 
                 'ncurses-devel', 'libxslt', "$printprotopkg" ]

}
