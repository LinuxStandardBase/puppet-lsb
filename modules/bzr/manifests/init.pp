class bzr {

    package {
        'bzr': ensure => present;
    }

    # bzr on SLES 11 is too old; add a repository on the openSUSE
    # Build Service for newer bzr.

    $skipsles11obs = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11(\.[0-9])?$/ => false,
        default               => true,
    }

    file { "/etc/zypp/repos.d/devel_tools_scm.repo":
        noop   => $skipsles11obs,
        source => "puppet:///modules/bzr/devel_tools_scm.repo",
        notify => Exec['refresh-zypper-keys'],
        before => Package['bzr'],
    }

    exec { 'refresh-zypper-keys':
        command     => 'zypper --gpg-auto-import-keys refresh',
        path        => [ '/usr/sbin', '/usr/bin', '/bin', '/sbin' ],
        refreshonly => true,
        logoutput   => true,
    }

}
