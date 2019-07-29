class systemd {

    exec { 'systemd-reload':
        command     => 'systemctl daemon-reload',
        path        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
        refreshonly => true
    }

}
