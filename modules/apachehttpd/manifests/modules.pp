class apachehttpd::modules {

    include apachehttpd

    include git

    # Pull in web database passwords and other web passwords.

    include webdb

    # Revisions we want for each module.  This is just passed to -r,
    # so any bzr revisionspec is allowed (revnos, tags, revids, etc.).

    $dbadminrev = 'revid:licquia@linuxfoundation.org-20141003153711-0xexdfw1peqxn418'
    $certrev = 'revid:licquia@linuxfoundation.org-20170829205246-yfzfbxa7s8se52qs'
    $prdbrev = 'revid:licquia@linuxfoundation.org-20141004212651-asp228c66o90sads'
    $refspecrev = 'revid:licquia@linuxfoundation.org-20170811184208-dqd5g8y83ondfzqb'
    $lananarev = '4d2d4ac2e4f6606bec277165ddb34a641b2c86f0'

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

    file { '/data/www/modules/lanana':
        ensure  => directory,
        require => File['/data/www/modules'],
    }

    exec { 'make-lanana-module':
        command => "git clone https://github.com/LinuxStandardBase/lanana.git lsbreg && cd lsbreg && git checkout $lananarev",
        cwd     => '/data/www/modules/lanana',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => '/data/www/modules/lanana/lsbreg',
        require => File['/data/www/modules/lanana'],
    }

    file { '/data/www/modules/lanana/index.html':
        ensure => link,
        target => 'lsbreg/index.html',
        require => Exec['make-lanana-module'],
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

    exec { 'update-lanana-module':
        command => "git fetch --all && git checkout $lananarev",
        cwd     => '/data/www/modules/lanana/lsbreg',
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => Exec['make-lanana-module'],
    }

    # The prdb app needs a way to modify and commit to the
    # problem_db bzr repository.

    $apacheuser = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11/       => 'wwwrun',
        /^OpenSuSE-13/   => 'wwwrun',
        /^CentOS-7/      => 'apache',
    }

    $apachehomedir = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11/       => '/var/lib/wwwrun',
        /^OpenSuSE-13/   => '/var/lib/wwwrun',
        /^CentOS-7/      => '/usr/share/httpd',
    }

    file { "$apachehomedir/.bazaar":
        ensure => directory,
        owner  => $apacheuser,
    }

    file { "$apachehomedir/.bazaar/bazaar.conf":
        owner   => $apacheuser,
        require => File["$apachehomedir/.bazaar"],
        content => '[DEFAULT]
email = Automatic Commit <lsb-discuss@lists.linuxfoundation.org>
ssl.cert_reqs=none
',
    }

    file { "$apachehomedir/.bazaar/authentication.conf":
        ensure  => absent,
        owner   => $apacheuser,
        mode    => '0640',
        require => File["$apachehomedir/.bazaar"],
        content => "[lsb]
scheme=https
host=bzr.linuxfoundation.org
user=autobuild
password=$webdb::autobuild
",
    }

    exec { 'checkout-problem-db':
        command     => "bzr checkout http://bzr.linuxfoundation.org/lsb/devel/problem_db $apachehomedir/problem_db",
        cwd         => $apachehomedir,
        path        => [ '/bin', '/usr/bin' ],
        environment => "BZR_HOME=$apachehomedir",
        creates     => "$apachehomedir/problem_db",
        user        => $apacheuser,
        require     => File["$apachehomedir/.bazaar/bazaar.conf"],
        logoutput   => on_failure,
    }

    exec { 'update-problem-db':
        command     => "bzr update $apachehomedir/problem_db",
        cwd         => "$apachehomedir/problem_db",
        path        => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        environment => "BZR_HOME=$apachehomedir",
        user        => $apacheuser,
        require     => Exec['checkout-problem-db'],
        logoutput   => on_failure,
    }

    exec { 'checkout-phpcas':
        command   => "git clone -n https://github.com/Jasig/phpCAS.git",
        cwd       => $apachehomedir,
        path      => [ '/bin', '/usr/bin' ],
        creates   => "$apachehomedir/phpCAS",
        user      => $apacheuser,
        logoutput => on_failure,
    }

    exec { 'update-phpcas':
        command => "git fetch && git checkout $phpcastag",
        cwd     => "$apachehomedir/phpCAS",
        path    => [ '/bin', '/usr/bin' ],
        user    => $apacheuser,
        require => Exec['checkout-phpcas'],
        logoutput => on_failure,
    }

}
