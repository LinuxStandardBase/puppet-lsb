class apachehttpd {

    $osdefault = "default-sles11"

    service { 'apache2':
        enable  => true,
        require => File['/etc/apache2/httpd.conf'],
    }

    package { 'apache2': ensure => present; }

    file { '/etc/apache2/httpd.conf':
        source  => [ "puppet:///modules/apachehttpd/httpd.conf/$fqdn", "puppet:///modules/apachehttpd/httpd.conf/$osdefault" ],
    }

    file { '/etc/sysconfig/apache2':
        source => [ "puppet:///modules/apachehttpd/sysconfig/$fqdn", "puppet:///modules/apachehttpd/sysconfig/$osdefault" ],
    }

}
