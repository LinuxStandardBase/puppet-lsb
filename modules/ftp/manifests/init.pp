class ftp {

    file { '/etc/cron.daily/update-manifests':
        source => [ "puppet:///modules/ftp/cron/update-manifests/$fqdn",
                    "puppet:///modules/mysql/cron/update-manifests/default" ],
        mode   => 0755,
    }

}
