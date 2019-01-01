class alien {

    # need alien, dpkg and dependencies to create .deb repos

    $alienrepo = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11(\.[0-9])?$/ => 'alien_for_sles11.repo',
        /^OpenSuSE-13\.1$/    => 'system_packagemanager_os13.1.repo',
        /^OpenSuSE-13\.2$/    => 'system_packagemanager_os13.2.repo',
        default               => undef,
    }

    $fakerootrepo = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^OpenSuSE-13\.1$/ => 'devel_tools_os13.1.repo',
        /^OpenSuSE-13\.2$/ => 'systemsmanagement_wbem_deps_os13.2.repo',
        default            => undef,
    }
    
    $dpkgversion = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11(\.[0-9])?$/ => '1.16.0.1-2lsb5',
        default               => present,
    }

    file { ['/opt/zypper', '/opt/zypper/alien_for_sles11']:
        ensure => directory,
        mode   => '0755',
    }

    if $alienrepo {
        file { "/etc/zypp/repos.d/alien.repo":
            source => "puppet:///modules/alien/${alienrepo}",
            notify => Exec['refresh-zypper-keys-for-alien'],
        }
    }
    
    if $fakerootrepo {
        file { "/etc/zypp/repos.d/fakeroot.repo":
            source => "puppet:///modules/alien/${fakerootrepo}",
            notify => Exec['refresh-zypper-keys-for-alien'],
        }
    }

    exec { 'refresh-zypper-keys-for-alien':
        command     => 'zypper --gpg-auto-import-keys refresh',
        path        => [ '/usr/sbin', '/usr/bin', '/bin', '/sbin' ],
        refreshonly => true,
        logoutput   => true,
    }

    # dependencies I needed to build the packages
    # not needed long term, from existing repos
    # package { ['zlib-devel', 'perl-SGMLS', 'perl-Text-CharWidth', 'automake', 'autoconf', 'pkg-config', 'util-linux']:
    #     ensure => present,
    # }

    # custom-built packages - src.rpms are in
    # http://bzr.linuxfoundation.org/lsb/devel/src_rpms_for_alien 

    # more build dependencies, had to build/provide these
    # package { ['perl-Text-WrapI18N', 'po4a']:
    #     ensure => present,
    # }

    # the bits we really want
    # the native 'deb' package also provides dpkg, use the new one
    package { 'dpkg':
        ensure => $dpkgversion,
    }
    package { ['alien', 'debhelper', 'fakeroot']:
        ensure => present,
    }
}
