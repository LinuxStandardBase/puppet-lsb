class apachehttpd::modules {

    # Pull in web database passwords and other web passwords.

    include webdb

    # Revisions we want for each module.  This is just passed to -r,
    # so any bzr revisionspec is allowed (revnos, tags, revids, etc.).

    $dbadminrev = 'revid:denis.silakov@rosalab.ru-20130401141239-ob3v5vf40t2hoyce'
    $certrev = 'revid:licquia@linuxfoundation.org-20120626045849-zsw9ke1pz8wsp7sm'
    $prdbrev = 'revid:licquia@linuxfoundation.org-20130403210502-fvfaoom70dhyu4qp'
    $refspecrev = 'revid:mats@linuxfoundation.org-20130529180431-pq8ao1t04vwex0yk'

    # Do initial checkouts of modules.

    exec { 'make-dbadmin-module':
        command => "bzr checkout -r $dbadminrev http://bzr.linuxfoundation.org/lsb/devel/dbadmin",
        cwd     => '/srv/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/dbadmin',
    }

    exec { 'make-lsbcert-module':
        command => "bzr checkout -r $certrev http://bzr.linuxfoundation.org/lsb/devel/lsb-cert",
        cwd     => '/srv/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/lsb-cert',
    }

    exec { 'make-prdb-module':
        command => "bzr checkout -r $prdbrev http://bzr.linuxfoundation.org/lsb/devel/prdb",
        cwd     => '/srv/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/prdb',
    }

    exec { 'make-refspec-module':
        command => "bzr checkout -r $refspecrev http://bzr.linuxfoundation.org/refspec/devel/refspec",
        cwd     => '/srv/www/modules',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/refspec',
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

}
