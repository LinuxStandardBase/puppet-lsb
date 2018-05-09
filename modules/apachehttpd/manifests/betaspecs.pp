class apachehttpd::betaspecs {

    include apachehttpd

    include apachehttpd::vhosts

    include bzr

    include make

    package {
        'xmlto': ensure => present;
    }

    file { '/etc/cron.daily/update-betaspecs':
        ensure => absent,
    }

    file { '/usr/local/bin/update-betaspecs':
        source => [ "puppet:///modules/apachehttpd/update-betaspecs" ],
        notify => Exec['do-update-betaspecs'],
        mode => '0755',
    }

    file { '/srv/www/vhosts/linuxbase.org':
        ensure  => directory,
        require => File['/srv/www/vhosts'],
    }

    file { '/srv/www/vhosts/linuxbase.org/betaspecs':
        ensure => directory,
        require => File['/srv/www/vhosts/linuxbase.org'],
    }

    file { '/srv/www/vhosts/linuxbase.org/snapshotspecs':
        ensure => directory,
        require => File['/srv/www/vhosts/linuxbase.org'],
    }

    file { '/srv/www/vhosts/linuxbase.org/betaspecs/lsb':
        ensure => directory,
        require => File['/srv/www/vhosts/linuxbase.org/betaspecs'],
    }

    file { '/srv/www/vhosts/linuxbase.org/snapshotspecs/lsb':
        ensure => directory,
        require => File['/srv/www/vhosts/linuxbase.org/snapshotspecs'],
    }

    file { '/srv/www/vhosts/linuxbase.org/betaspecs/index.html':
        source => "puppet:///modules/apachehttpd/content/betaspecs/index.html",
        require => File['/srv/www/vhosts/linuxbase.org/betaspecs'],
    }

    file { '/srv/www/vhosts/linuxbase.org/betaspecs/lsb/index.html':
        source => "puppet:///modules/apachehttpd/content/betaspecs/lsb/index.html",
        require => File['/srv/www/vhosts/linuxbase.org/betaspecs/lsb'],
    }

    file { '/srv/www/vhosts/linuxbase.org/snapshotspecs/index.html':
        source => "puppet:///modules/apachehttpd/content/snapshotspecs/index.html",
        require => File['/srv/www/vhosts/linuxbase.org/snapshotspecs'],
    }

    file { '/srv/www/vhosts/linuxbase.org/snapshotspecs/lsb/index.html':
        source => "puppet:///modules/apachehttpd/content/snapshotspecs/lsb/index.html",
        require => File['/srv/www/vhosts/linuxbase.org/snapshotspecs/lsb'],
    }

    exec { 'do-update-betaspecs':
        command => '/usr/local/bin/update-betaspecs',
        path => [ '/usr/sbin', '/usr/bin', '/bin' ],
        timeout => 600,
        refreshonly => true,
        logoutput => on_failure,
    }

    cron { 'regular-update-betaspecs':
        command => '/usr/local/bin/update-betaspecs',
        user    => root,
        hour    => 3,
        minute  => 0,
    }

}
