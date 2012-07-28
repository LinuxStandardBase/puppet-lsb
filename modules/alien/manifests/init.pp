class alien {

    # need alien, dpkg and dependencies to create .deb repos

    $sles11alienrepo = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11(\.[0-9])?$/ => File['/etc/zypp/repos.d/alien_for_sles11.repo'],
        default               => undef,
    }

    $dpkgversion = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11(\.[0-9])?$/ => '1.16.0.1',
        default               => present,
    }

    file { ['/opt/zypper', '/opt/zypper/alien_for_sles11']:
        ensure => directory,
        mode   => 0755,
    }

    if $sles11alienrepo {
        file { "/etc/zypp/repos.d/alien_for_sles11.repo":
            source => "puppet:///modules/alien/alien_for_sles11.repo",
        }
    }
    
    # dependencies I needed to build the packages
    # not needed long term, from existing repos
    package { ['zlib-devel', 'perl-SGMLS', 'perl-Text-CharWidth']:
        ensure => present,
    }

    # custom-built packages - src.rpms are in
    # http://bzr.linuxfoundation.org/lsb/devel/src_rpms_for_alien 

    # more build dependencies, had to build/provide these
    package { ['perl-Text-WrapI18N', 'po4a']:
        ensure => present,
    }

    # the bits we really want
    # the native 'deb' package also provides dpkg, use the new one
    package { 'dpkg':
        ensure => $dpkgversion,
        require => $sles11alienrepo,
    }
    package { ['alien', 'perl-Dpkg', 'debhelper']:
        ensure => present,
        require => $sles11alienrepo,
    }
}
