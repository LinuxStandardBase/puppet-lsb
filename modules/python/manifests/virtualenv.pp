class python::virtualenv inherits python {

    # These packages aren't available in SLES 11, so we'll need
    # to add the repos first.

    $sles11obsrepo = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11(\.[0-9])?$/ => File['/etc/zypp/repos.d/devel_languages_python_sles11.repo'],
        /^OpenSuSE-11\.4$/    => File['/etc/zypp/repos.d/devel_languages_python_opensuse11.repo'],
        default               => undef,
    }

    package { 'python-virtualenv': 
        ensure  => present,
        require => $sles11obsrepo,
    }

    package { 'python-pip':
        ensure => present,
        require => $sles11obsrepo,
    }

    if $sles11obsrepo {
        file { "/etc/zypp/repos.d/devel_languages_python.repo":
            source => "puppet:///modules/python/devel_languages_python.repo",
            notify => Exec['refresh-zypper-keys-for-python'],
        }

        exec { 'refresh-zypper-keys-for-python':
            command     => 'zypper --gpg-auto-import-keys refresh',
            path        => [ '/usr/sbin', '/usr/bin', '/bin', '/sbin' ],
            refreshonly => true,
            logoutput   => true,
        }
    }

}
