class python::virtualenv inherits python {

    # These packages aren't available in certain SUSE variants, so we'll need
    # to add the repos first.

    $osid = "$operatingsystem-$operatingsystemrelease"

    $suseobsrepo = "$osid" ? {
        /^SLES-11(\.[0-9])?$/ => File['/etc/zypp/repos.d/devel_languages_python.repo'],
        /^OpenSuSE-11\.4$/    => File['/etc/zypp/repos.d/devel_languages_python.repo'],
        default               => undef,
    }

    $susereposrc = "$osid" ? {
        /^SLES-11(\.[0-9])?$/ => "devel_languages_python_sles11.repo",
        /^OpenSuSE-11\.4$/    => "devel_languages_python_opensuse11.repo",
        default               => undef,
    }

    package { 'python-virtualenv': 
        ensure  => present,
        require => $suseobsrepo,
    }

    package { 'python-pip':
        ensure => present,
        require => $suseobsrepo,
    }

    if $suseobsrepo {
        file { "/etc/zypp/repos.d/devel_languages_python.repo":
            source => "puppet:///modules/python/$susereposrc",
            notify => Exec['refresh-zypper-keys-for-python'],
        }

        exec { 'refresh-zypper-keys-for-python':
            command     => 'zypper --gpg-auto-import-keys refresh',
            path        => [ '/usr/sbin', '/usr/bin', '/bin', '/sbin' ],
            refreshonly => true,
            logoutput   => true,
        }

        package { 'python-distribute':
            ensure => present,
        }

    }

}
