class bzr {

    # bzr on SLES 11 is too old; add a repository on the openSUSE
    # Build Service for newer bzr.

    $sles11obsrepo = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11(\.[0-9])?$/ => File['/etc/zypp/repos.d/devel_tools_scm.repo'],
        default               => undef,
    }

    $bzrversion = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11(\.[0-9])?$/ => '2.4.1-18.1',
        default               => present,
    }

    if $sles11obsrepo {
        file { "/etc/zypp/repos.d/devel_tools_scm.repo":
            source => "puppet:///modules/bzr/devel_tools_scm.repo",
            notify => Exec['refresh-zypper-keys-for-bzr'],
        }

        exec { 'refresh-zypper-keys-for-bzr':
            command     => 'zypper --gpg-auto-import-keys refresh',
            path        => [ '/usr/sbin', '/usr/bin', '/bin', '/sbin' ],
            refreshonly => true,
            logoutput   => true,
        }
    }

    package { 'bzr':
        ensure => $bzrversion,
        require => $sles11obsrepo,
    }

}
