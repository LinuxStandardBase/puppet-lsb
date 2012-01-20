class apachehttpd::betaspecs {

    include apachehttpd::vhosts

    include bzr

    package {
        'xmlto': ensure => present;
        'make': ensure => present;
    }

    file { '/etc/cron.daily/update-betaspecs':
        source => [ "puppet:///modules/apachehttpd/update-betaspecs" ],
        notify => Exec['do-update-betaspecs'],
        mode => 0755,
    }

    file { '/srv/www/vhosts/linuxbase.org/betaspecs/index.html':
        source => "puppet:///modules/apachehttpd/content/betaspecs/index.html",
    }

    exec { 'do-update-betaspecs':
        command => '/etc/cron.daily/update-betaspecs',
        path => [ '/usr/sbin', '/usr/bin', '/bin' ],
        refreshonly => true,
        logoutput => on_failure,
    }

}
