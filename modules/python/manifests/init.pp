class python {

    package {
        'python': ensure => present;
    }

    if ($operatingsystem == "CentOS") and ($operatingsystemrelease < 7) {
        package { 'python-argparse': ensure => present; }
    }

}
