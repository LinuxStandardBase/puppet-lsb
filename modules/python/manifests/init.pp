class python {

    package {
        'python': ensure => present;
    }

    if ($operatingsystem == "CentOS") and ($operatingsystemmajrelease == "6") {
        package { 'python-argparse': ensure => present; }
    }

}
