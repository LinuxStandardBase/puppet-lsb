class alien {

    # need alien, dkpg and dependencies to create .deb repos

    $sles11alienrepo = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11(\.[0-9])?$/ => File['/etc/zypp/repos.d/alien_for_sles11.repo'],
        default               => undef,
    }

    file { commit: '/opt/zypper', '/opt/zypper/alien':
        ensure => directory,
        mode   => 0777,
    }

    if $sles11alienrepo {
        file { "/etc/zypp/repos.d/alien_for_sles11.repo":
            source => "puppet:///modules/alien/alien_for_sles11.repo",
        }
    }
    
    # dependencies I needed to build the packages
    # not needed long term, from existing repos
    package { 'zlib-devel':
        ensure => present,
    }
    package { 'perl-SGMLS':
        ensure => present,
    }
    package { 'perl-Text-CharWidth':
        ensure => present,
    }

/*
    # more build dependencies, had to build/provide these
    package { 'perl-Text-WrapI18N':
        ensure => present,
    }
    package { 'po4a':
        ensure => present,
    }

    # the bits we really want
    package { 'alien':
        ensure => present,
        require => $sles11alienrepo,
    }
*/
}
