class ftp {

    include bzr

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
