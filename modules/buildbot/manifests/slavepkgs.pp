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
        /^Fedora$/  => ['libXi-devel', 'libXext-devel', 'libXtst-devel', 'libXt-devel', 'libXdmcp-devel'],
        /^CentOS$/  => ['libXi-devel', 'libXext-devel', 'libXtst-devel', 'libXt-devel', 'libXdmcp-devel'],
        /^SLES/     => 'xorg-x11-devel',
        /^OpenSuSE/ => 'xorg-x11-devel',
        default     => 'libxorg-x11-devel',
    }

    $xdevel32pkg = "$operatingsystem-$architecture" ? {
        /^Fedora-s390x$/ => ['libX11-devel.s390', 'libXext-devel.s390',
                             'libXtst-devel.s390', 'libXt-devel.s390',
                             'libXdmcp-devel.s390', 'libXi-devel.s390'],
        default          => ['libX11-devel-32bit', 'libXext-devel-32bit',
                             'libXtst-devel-32bit', 'libXt-devel-32bit',
                             'libXdmcp-devel-32bit', 'libXi-devel-32bit'],
    }

    # this one for xts5 and lsb-xvfb
    $fontutilpkg = $operatingsystem ? {
        /^Fedora$/  => 'xorg-x11-font-utils',
        /^CentOS$/  => 'xorg-x11-font-utils',
        /^SLES/     => ['xorg-x11', 'xorg-x11-fonts-devel'],
        /^OpenSuSE/ => ['xorg-x11', 'mkfontdir', 'mkfontscale', 'bdftopcf', 'font-util'],
        default     => 'x11-font-util',
    }

    $lsbpkg = $operatingsystem ? {
        /^Fedora$/ => ['redhat-lsb', 'qt'],
        /^CentOS$/ => ['redhat-lsb', 'qt'],
        default    => 'lsb',
    }

    $rpmpkg = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-.+$/     => 'rpm',
        /^OpenSuSE-.+$/ => 'rpm-build',
        default         => 'rpm-build',
    }

    $gpluspluspkg = $operatingsystem ? {
        default      => 'gcc-c++',
    }

    $cppdevelpkg = $operatingsystem ? {
        default => 'libstdc++-devel',
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
        /^OpenSuSE/     => 'java-1_7_0-openjdk',
        default         => 'openjdk',
    }

    $pkgconfigpkg = $operatingsystem ? {
        /^SLES/     => 'pkg-config',
        /^OpenSuSE/ => 'pkg-config',
        default     => 'pkgconfig',
    }

    $xgettextpkg = $operatingsystem ? {
        /^SLES/     => 'gettext-tools',
        /^OpenSuSE/ => 'gettext-tools',
        default     => 'gettext',
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
        /^SLES/     => 'libexpat-devel',
        /^OpenSuSE/ => 'libexpat-devel',
        /^CentOS/   => 'expat-devel',
        /^Fedora/   => 'expat-devel',
        default     => 'libexpat-dev',
    }

    # runtime-test for 4.0 still uses expect
    $expectpkg = $operatingsystem ? {
        /^SLES/   => 'expect',
        default   => 'expect',
    }

    # bison used to provide yacc for runtime-test, now it's byacc sometimes
    $bisonpkg = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^CentOS-[56]/ => 'byacc',
        default        => 'bison',
    }

    # automake 1.4 is needed by the gtkvts portion of desktop-test
    $automakepkg = $operatingsystem ? {
        default   => 'automake',
    }
    
    # need libc.a to build a chroot test in runtime-test and for lsbrun

    $libcstaticpkg = $operatingsystem ? {
        /^SLES/     => 'glibc-devel',
        /^OpenSuSE/ => 'glibc-devel-static',
        /^CentOS/   => 'glibc-static',
        /^Fedora/   => 'glibc-static',
        default     => 'glibc-static-devel',
    }

    $libcstatic32pkg = "$operatingsystem-$architecture" ? {
        /^SLES/          => 'glibc-devel-32bit',
        /^OpenSuSE/      => 'glibc-devel-static-32bit',
        /^Fedora-s390x$/ => 'glibc-static.s390',
        default          => 'glibc-static-devel',
    }

    # for 32-bit environments, make sure to add 32-bit C++

    $cpp32pkg = "$operatingsystem-$architecture" ? {
        /^OpenSuSE/      => 'libstdc++47-devel-32bit',
        /^SLES/          => 'libstdc++43-devel-32bit',
        /^Fedora-s390x$/ => 'libstdc++-devel.s390',
        default          => 'libstdc++-devel-32bit',
    }

    # other 32-bit pkgs needed

    $lsb32pkg = "$operatingsystem-$architecture" ? {
        /^Fedora-s390x$/ => 'redhat-lsb.s390',
        default          => 'error-package',
    }

    $libc32pkg = "$operatingsystem-$architecture" ? {
        /^Fedora-s390x$/ => 'glibc-devel.s390',
        default          => 'glibc-devel-32bit',
    }

    $zlib32pkg = "$operatingsystem-$architecture" ? {
        /^Fedora-s390x$/ => 'zlib-devel.s390',
        default          => 'zlib-32bit',
    }

    $ncurses32pkg = "$operatingsystem-$architecture" ? {
        /^Fedora-s390x$/ => 'ncurses-devel.s390',
        default          => 'ncurses-devel-32bit',
    }

    $expat32pkg = "$operatingsystem-$architecture" ? {
        /^Fedora-s390x$/ => 'expat-devel.s390',
        default          => 'libexpat-devel-32bit',
    }

    $gtk32pkg = "$operatingsystem-$architecture" ? {
        /^Fedora-s390x$/ => 'gtk2.s390',
        default          => 'libgtk-2_0-0-32bit',
    }

    $png32pkg = "$operatingsystem-$architecture" ? {
        /^Fedora-s390x$/ => 'libpng12.s390',
        default          => 'libpng12-0-32bit',
    }

    # Apparently, libbat needs the printproto stuff to be
    # installed.  This should be built and used as part of
    # the libbat build; need to investigate.
    $printprotopkg = $operatingsystem ? {
        /^SLES/   => 'xorg-x11-proto-devel',
        /^CentOS/ => 'libXp-devel',
        default   => 'libXp-devel',
    }

    # libxslt
    $libxsltpkg = $operatingsystem ? {
        /^OpenSuSE/ => 'libxslt1',
        default     => 'libxslt',
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
    $cairogobjectpkg = $operatingsystem ? {
        /^SLES/   => 'cairo-gobject-devel',
        /^Fedora/ => 'cairo-gobject-devel',
        default   => '',
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
    $gtk2pkg = $operatingsystem ? {
        /^SLES/   => 'gtk2-devel',
        default   => 'gtk2-devel',
    }
    $gtk3pkg = $operatingsystem ? {
        /^SLES/   => 'gtk3-devel',
        default   => 'gtk3-devel',
    }
    $jpegpkg = $operatingsystem ? {
        /^SLES/   => 'libjpeg-devel',
        /^Fedora/ => 'libjpeg-turbo-devel',
        default   => 'libjpeg-devel',
    }
    $glpkg = $operatingsystem ? {
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
    $pngdevpkg = $operatingsystem ? {
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
                    "$gtk2pkg", "$gtk3pkg", "$jpegpkg", "$glpkg",
                    'libxml2-devel', "$nsprpkg", "$nsspkg", "$pangopkg",
                    "$pngdevpkg", "$zlibpkg", "$xprotopkg", "$xrenderpkg",
                    "$kernelpkg", "$sanepkg", "$xkbpkg", 'libxslt-devel',
                    "$tiffpkg", "$cairogobjectpkg" ]
    # end devchk
    
    # command for forcing the small-word environment
    $smallwordpkg = "$operatingsystem-$architecture" ? {
        'SLES-s390x'   => 's390-32',
        'Fedora-s390x' => 'util-linux',
        /ppc64$/       => 'powerpc32',
        default        => '',
    }

    # Most packages needed for a typical slave; see the definitions
    # above for $fontutilpkg and $xdevelpkg for the interesting ones.
    $pkglist = [ "$rpmpkg", "$gpluspluspkg", "$cppdevelpkg", "$pkgconfigpkg",
                 'cvs', "$javapkg", 'autoconf', "$automakepkg", 'libtool',
                 "$bisonpkg", 'flex', "$xgettextpkg", 'rsync', "$intltoolpkg",
                 "$glibdevelpkg", "$pamdevelpkg", "$expectpkg",
                 "$expatdevelpkg", 'perl', "$libcstaticpkg", 
                 'ncurses-devel', "$libxsltpkg", "$printprotopkg" ]

}
