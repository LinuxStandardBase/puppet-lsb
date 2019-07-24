class apachehttpd {

    $osdefault = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11/       => 'default-sles11',
        /^OpenSuSE-13/   => 'default-sles11',
        /^CentOS-7/      => 'default-rhel7',
    }

    $configpath = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11/       => '/etc/apache2',
        /^OpenSuSE-13/   => '/etc/apache2',
        /^CentOS-7/      => '/etc/httpd',
    }

    $pkgname = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11/       => 'apache2',
        /^OpenSuSE-13/   => 'apache2',
        /^CentOS-7/      => 'httpd',
    }

    package { '$pkgname': ensure => present; }

    case $operatingsystem {
        /^(SLES|OpenSuSE)$/: {
            service { 'apache2':
                enable  => true,
                require => File['/etc/apache2/httpd.conf'],
            }

            file { '/etc/apache2/httpd.conf':
                source  => [ "puppet:///modules/apachehttpd/httpd.conf/$fqdn", "puppet:///modules/apachehttpd/httpd.conf/$osdefault" ],
            }

            file { '/etc/apache2/listen.conf':
                source  => [ "puppet:///modules/apachehttpd/listen.conf/$fqdn", "puppet:///modules/apachehttpd/listen.conf/$osdefault" ],
            }

            file { '/etc/apache2/local.conf':
                source  => [ "puppet:///modules/apachehttpd/local.conf/$fqdn", "puppet:///modules/apachehttpd/local.conf/$osdefault" ],
            }

            file { '/etc/sysconfig/apache2':
                source => [ "puppet:///modules/apachehttpd/sysconfig/$fqdn", "puppet:///modules/apachehttpd/sysconfig/$osdefault" ],
            }
        }
        /^(CentOS|RHEL)$/: {
            service { 'httpd':
                enable  => true,
                require => File['/etc/httpd/conf/httpd.conf'],
            }

            file { '/etc/httpd/conf/httpd.conf':
                source  => [ "puppet:///modules/apachehttpd/httpd.conf/$fqdn", "puppet:///modules/apachehttpd/httpd.conf/$osdefault" ],
            }
        }
    }

    file { '/srv/www':
        ensure => directory,
    }

}
