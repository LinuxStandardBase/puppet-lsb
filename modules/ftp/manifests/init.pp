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

    file { '/etc/cron.daily/update-manifests':
        source => [ "puppet:///modules/ftp/cron/update-manifests/$fqdn",
                    "puppet:///modules/ftp/cron/update-manifests/default" ],
        mode   => 0755,
    }

    file { '/opt/ftp-maint/manifest/manifest_rebuild_s.sh':
        source => "puppet:///modules/ftp/cron/update-manifests/manifest_rebuild_s.sh",
        mode   => 0755,
        group  => 'users',
        owner  => 'lfadmin',
    }

    file { '/etc/cron.daily/update-problem-db2':
        source => [ "puppet:///modules/ftp/cron/update-problem-db2/$fqdn",
                    "puppet:///modules/ftp/cron/update-problem-db2/default" ],
        mode   => 0755,
    }

}
