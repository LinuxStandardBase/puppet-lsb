class apachehttpd::modules {

    include apachehttpd

    include git

    # Pull in web database passwords and other web passwords.

    include webdb

    # Revisions we want for each module.  This is just passed to -r,
    # so any bzr revisionspec is allowed (revnos, tags, revids, etc.).

    $dbadminrev = 'revid:licquia@linuxfoundation.org-20141003153711-0xexdfw1peqxn418'
    $certrev = 'revid:licquia@linuxfoundation.org-20141008010712-rghgrqchy8hbeove'
    $prdbrev = 'revid:licquia@linuxfoundation.org-20141004212651-asp228c66o90sads'
    $refspecrev = 'revid:mats@linuxfoundation.org-20130529180431-pq8ao1t04vwex0yk'

    # Revisions for dependencies.

    $phpcastag = '1.3.2'

    file { '/srv/www/modules':
        ensure  => directory,
        require => File['/srv/www'],
    }

    # Do initial checkouts of modules.

    exec { 'make-dbadmin-module':
        command => "bzr checkout -r $dbadminrev http://bzr.linuxfoundation.org/lsb/devel/dbadmin",
        cwd     => '/srv/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/dbadmin',
        require => File['/srv/www/modules'],
    }

    exec { 'make-lsbcert-module':
        command => "bzr checkout -r $certrev http://bzr.linuxfoundation.org/lsb/devel/lsb-cert",
        cwd     => '/srv/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/lsb-cert',
        require => File['/srv/www/modules'],
    }

    exec { 'make-prdb-module':
        command => "bzr checkout -r $prdbrev http://bzr.linuxfoundation.org/lsb/devel/prdb",
        cwd     => '/srv/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/prdb',
        require => File['/srv/www/modules'],
    }

    exec { 'make-refspec-module':
        command => "bzr checkout -r $refspecrev http://bzr.linuxfoundation.org/refspec/devel/refspec",
        cwd     => '/srv/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/refspec',
        require => File['/srv/www/modules'],
    }

    # Set module configuration files.

    file { '/srv/www/modules/dbadmin/config/connection.inc':
        content => template('apachehttpd/dbconfig/dbadmin.erb'),
    }

    file { '/srv/www/modules/lsb-cert/config.inc.php':
        content => template('apachehttpd/dbconfig/lsb-cert.erb'),
    }

    file { '/srv/www/modules/prdb/config.inc.php':
        content => template('apachehttpd/dbconfig/prdb.erb'),
    }

    # Check for and pull updates for modules.

    exec { 'update-dbadmin-module':
        command => "bzr update -r $dbadminrev /srv/www/modules/dbadmin",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-dbadmin-module'],
    }

    exec { 'update-lsbcert-module':
        command => "bzr update -r $certrev /srv/www/modules/lsb-cert",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-lsbcert-module'],
    }

    exec { 'update-prdb-module':
        command => "bzr update -r $prdbrev /srv/www/modules/prdb",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-prdb-module'],
    }

    exec { 'update-refspec-module':
        command => "bzr update -r $refspecrev /srv/www/modules/refspec",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-refspec-module'],
    }

    # The prdb app needs a way to modify and commit to the
    # problem_db bzr repository.

    file { '/var/lib/wwwrun/.bazaar':
        ensure => directory,
        owner  => 'wwwrun',
    }

    file { '/var/lib/wwwrun/.bazaar/bazaar.conf':
        owner   => 'wwwrun',
        require => File['/var/lib/wwwrun/.bazaar'],
        content => '[DEFAULT]
email = Automatic Commit <lsb-discuss@lists.linuxfoundation.org>
',
    }

    file { '/var/lib/wwwrun/.bazaar/authentication.conf':
        owner   => 'wwwrun',
        mode    => 0640,
        require => File['/var/lib/wwwrun/.bazaar'],
        content => "[lsb]
scheme=https
host=bzr.linuxfoundation.org
user=autobuild
password=$webdb::autobuild
",
    }

    exec { 'checkout-problem-db':
        command     => 'bzr checkout https+urllib://bzr.linuxfoundation.org/lsb/devel/problem_db /var/lib/wwwrun/problem_db',
        cwd         => '/var/lib/wwwrun',
        path        => [ '/bin', '/usr/bin' ],
        environment => 'BZR_HOME=/var/lib/wwwrun',
        creates     => '/var/lib/wwwrun/problem_db',
        user        => 'wwwrun',
        require     => [ File['/var/lib/wwwrun/.bazaar/authentication.conf'],
                         File['/var/lib/wwwrun/.bazaar/bazaar.conf'] ],
        logoutput   => on_failure,
    }

    exec { 'update-problem-db':
        command     => "bzr update /var/lib/wwwrun/problem_db",
        cwd         => '/var/lib/wwwrun/problem_db',
        path        => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        environment => 'BZR_HOME=/var/lib/wwwrun',
        user        => 'wwwrun',
        require     => Exec['checkout-problem-db'],
        logoutput   => on_failure,
    }

    exec { 'checkout-phpcas':
        command   => "git clone -n https://github.com/Jasig/phpCAS.git",
        cwd       => '/var/lib/wwwrun',
        path      => [ '/bin', '/usr/bin' ],
        creates   => '/var/lib/wwwrun/phpCAS',
        user      => 'wwwrun',
        logoutput => on_failure,
    }

    exec { 'update-phpcas':
        command => "git fetch && git checkout $phpcastag",
        cwd     => '/var/lib/wwwrun/phpCAS',
        path    => [ '/bin', '/usr/bin' ],
        user    => 'wwwrun',
        require => Exec['checkout-phpcas'],
        logoutput => on_failure,
    }

}
