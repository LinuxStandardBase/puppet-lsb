class logrotate::web {

    include logrotate

    file { '/etc/logrotate.d/apache2extra':
        source => "puppet:///modules/logrotate/apache2extra",
    }

}
