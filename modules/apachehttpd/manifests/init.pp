class httpd {

    $osdefault = "default-sles11"

    service { 'apache2':
        enable  => true,
        require => File['/etc/apache2/httpd.conf'],
    }

    package { 'apache2': ensure => present; }

    file { '/etc/apache2/httpd.conf':
        source  => [ "puppet:///modules/httpd/httpd.conf/$fqdn", "puppet:///modules/httpd/httpd.conf/$osdefault" ],
    }

    file { '/etc/sysconfig/apache2':
        source => [ "puppet:///modules/httpd/sysconfig/$fqdn", 'puppet:///modules/httpd/sysconfig/$osdefault' ],
    }

}
