class apachehttpd::modules {

    $dbadminrev = 'revid:licquia@linuxfoundation.org-20120222174745-komaytu3rpkmyd5k'
    $certrev = 'revid:licquia@licquia.org-20111228203501-46t7fzgrf3q2166n'
    $prdbrev = 'revid:stewb@linux-foundation.org-20110413225941-02hl9ije28ol0qc6'

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
