class apachehttpd::modules {

    include apachehttpd

    include git

    # Pull in web database passwords and other web passwords.

    include webdb

    # Revisions we want for each module.  This is just passed to -r,
    # so any bzr revisionspec is allowed (revnos, tags, revids, etc.).

    $dbadminrev = 'revid:licquia@linuxfoundation.org-20141003153711-0xexdfw1peqxn418'
    $certrev = 'revid:licquia@linuxfoundation.org-20150527130220-xxocfqyfs96u9e2k'
    $prdbrev = 'revid:licquia@linuxfoundation.org-20141004212651-asp228c66o90sads'
    $refspecrev = 'revid:licquia@linuxfoundation.org-20170811184208-dqd5g8y83ondfzqb'

    # Revisions for dependencies.

    $phpcastag = '1.3.2'

    file { '/data/www':
        ensure => directory,
    }

    file { '/data/www/modules':
        ensure  => directory,
        require => File['/data/www'],
    }

    # Do initial checkouts of modules.

    exec { 'make-dbadmin-module':
        command => "bzr checkout -r $dbadminrev http://bzr.linuxfoundation.org/lsb/devel/dbadmin",
        cwd     => '/data/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/data/www/modules/dbadmin',
        require => File['/data/www/modules'],
    }

    exec { 'make-lsbcert-module':
        command => "bzr checkout -r $certrev http://bzr.linuxfoundation.org/lsb/devel/lsb-cert",
        cwd     => '/data/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/data/www/modules/lsb-cert',
        require => File['/data/www/modules'],
    }

    exec { 'make-prdb-module':
        command => "bzr checkout -r $prdbrev http://bzr.linuxfoundation.org/lsb/devel/prdb",
        cwd     => '/data/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/data/www/modules/prdb',
        require => File['/data/www/modules'],
    }

    exec { 'make-refspec-module':
        command => "bzr checkout -r $refspecrev http://bzr.linuxfoundation.org/refspec/devel/refspec",
        cwd     => '/data/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/data/www/modules/refspec',
        require => File['/data/www/modules'],
    }

    # Also do a staging version of (some of) the above modules.

    exec { 'make-refspec-staging-module':
        command => "bzr checkout -r -1 http://bzr.linuxfoundation.org/refspec/devel/refspec refspec-staging",
        cwd     => '/data/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/data/www/modules/refspec-staging',
        require => File['/data/www/modules'],
    }

    # Set module configuration files.

    file { '/data/www/modules/dbadmin/config/connection.inc':
        content => template('apachehttpd/dbconfig/dbadmin.erb'),
    }

    file { '/data/www/modules/lsb-cert/config.inc.php':
        content => template('apachehttpd/dbconfig/lsb-cert.erb'),
    }

    file { '/data/www/modules/prdb/config.inc.php':
        content => template('apachehttpd/dbconfig/prdb.erb'),
    }

    # Check for and pull updates for modules.

    exec { 'update-dbadmin-module':
        command => "bzr update -r $dbadminrev /data/www/modules/dbadmin",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-dbadmin-module'],
    }

    exec { 'update-lsbcert-module':
        command => "bzr update -r $certrev /data/www/modules/lsb-cert",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-lsbcert-module'],
    }

    exec { 'update-prdb-module':
        command => "bzr update -r $prdbrev /data/www/modules/prdb",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-prdb-module'],
    }

    exec { 'update-refspec-module':
        command => "bzr update -r $refspecrev /data/www/modules/refspec",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-refspec-module'],
    }

    exec { 'update-refspec-staging-module':
        command => "bzr update -r -1 /data/www/modules/refspec-staging",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-refspec-staging-module'],
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
