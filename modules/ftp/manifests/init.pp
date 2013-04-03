class ftp {

    include bzr

    package { 'vsftpd': ensure => present }

    file { '/etc/vsftpd.conf':
        source  => 'puppet:///modules/ftp/vsftpd.conf',
        mode    => 0600,
        require => Package['vsftpd'],
        notify  => Service['vsftpd'],
    }

    service { 'vsftpd':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        require    => [ Package['vsftpd'], File['/etc/vsftpd.conf'] ],
    }

    file { '/srv/ftp/incoming':
        ensure => directory,
        mode   => 0777,
    }

    # Scripts for updating information on the FTP server.

    file {
        '/etc/cron.daily/update-manifests': ensure => absent;
        '/etc/cron.daily/update-problem-db2': ensure => absent;
    }

    file { '/usr/local/bin/update-manifests':
        source => [ "puppet:///modules/ftp/cron/update-manifests/$fqdn",
                    "puppet:///modules/ftp/cron/update-manifests/default" ],
        mode   => 0755,
        notify => Exec['do-update-manifests'],
    }

    file { '/opt/ftp-maint/manifest/manifest_rebuild_s.sh':
        source => "puppet:///modules/ftp/cron/update-manifests/manifest_rebuild_s.sh",
        mode   => 0755,
        group  => 'users',
        owner  => 'lfadmin',
        notify => Exec['do-update-manifests'],
    }

    file { '/usr/local/bin/update-problem-db2':
        source => [ "puppet:///modules/ftp/cron/update-problem-db2/$fqdn",
                    "puppet:///modules/ftp/cron/update-problem-db2/default" ],
        mode   => 0755,
        notify => Exec['do-update-problem-db2'],
    }

    exec { 'do-update-manifests':
        command => '/usr/local/bin/update-manifests',
        path => [ '/usr/sbin', '/usr/bin', '/bin' ],
        timeout => 600,
        refreshonly => true,
        logoutput => on_failure,
    }

    cron { 'regular-update-manifests':
        command => '/usr/local/bin/update-manifests',
        user    => root,
        hour    => 3,
        minute  => 15,
    }

    exec { 'do-update-problem-db2':
        command => '/usr/local/bin/update-problem-db2',
        path => [ '/usr/sbin', '/usr/bin', '/bin' ],
        timeout => 600,
        refreshonly => true,
        logoutput => on_failure,
    }

    cron { 'regular-update-problem-db2':
        command => '/usr/local/bin/update-problem-db2',
        user    => root,
        hour    => '3,6,9,12,15,18,21',
        minute  => 37,
    }

}
