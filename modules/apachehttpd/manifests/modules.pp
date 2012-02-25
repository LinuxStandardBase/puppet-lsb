class apachehttpd::modules {

    # Pull in web database passwords.  These are actually used in the
    # db config templates.

    include webdb

    # Revisions we want for each module.  This is just passed to -r,
    # so any bzr revisionspec is allowed (revnos, tags, revids, etc.).

    $dbadminrev = 'revid:licquia@linuxfoundation.org-20120222174745-komaytu3rpkmyd5k'
    $certrev = 'revid:licquia@licquia.org-20111228203501-46t7fzgrf3q2166n'
    $prdbrev = 'revid:licquia@linuxfoundation.org-20120225020936-u3fbaj4ecvxllpee'

    # Do initial checkouts of modules.

    exec { 'make-dbadmin-module':
        command => "cd /srv/www/modules && bzr checkout -r $dbadminrev http://bzr.linuxfoundation.org/lsb/devel/dbadmin",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/dbadmin',
    }

    exec { 'make-lsbcert-module':
        command => "cd /srv/www/modules && bzr checkout -r $certrev http://bzr.linuxfoundation.org/lsb/devel/lsb-cert",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/lsb-cert',
    }

    exec { 'make-prdb-module':
        command => "cd /srv/www/modules && bzr checkout -r $prdbrev http://bzr.linuxfoundation.org/lsb/devel/prdb",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/srv/www/modules/prdb',
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

}
