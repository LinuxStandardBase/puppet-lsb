class python::virtualenv inherits python {

    package { 'python-virtualenv': 
        ensure => present,
    }

    package { 'python-pip':
        ensure => present,
    }

    # These packages aren't available in SLES 11, so we'll need
    # to add the repos first.

    $skipsles11obs = "$operatingsystem-$operatingsystemrelease" ? {
        /^SLES-11(\.[0-9])?$/ => false,
        default               => true,
    }

    exec { 'add-python-zypper-repo':
        command     => 'zypper addrepo -f http://download.opensuse.org/repositories/devel:/languages:/python/SLE_11/devel:languages:python.repo && zypper --gpg-auto-import-keys refresh',
        path        => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        refreshonly => true,
        logoutput   => true,
        before      => Package[ 'python-virtualenv', 'python-pip' ]
        noop        => $skipsles11obs,
    }

}
