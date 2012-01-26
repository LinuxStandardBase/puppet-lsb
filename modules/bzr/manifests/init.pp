class bzr {

    # bzr on SLES 11 is too old; add a repository on the openSUSE
    # Build Service for newer bzr.

    $sles11obsrepo = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11(\.[0-9])?$/ => File['/etc/zypp/repos.d/devel_tools_scm.repo'],
        default               => undef,
    }

    package { 'bzr':
        ensure => present,
        require => $sles11obsrepo,
    }

    file { "/etc/zypp/repos.d/devel_tools_scm.repo":
        noop   => $skipsles11obs,
        source => "puppet:///modules/bzr/devel_tools_scm.repo",
        notify => Exec['refresh-zypper-keys-for-bzr'],
        before => Package['bzr'],
    }

    exec { 'refresh-zypper-keys-for-bzr':
        command     => 'zypper --gpg-auto-import-keys refresh',
        path        => [ '/usr/sbin', '/usr/bin', '/bin', '/sbin' ],
        refreshonly => true,
        logoutput   => true,
    }

}
