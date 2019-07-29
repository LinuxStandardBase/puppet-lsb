class supybot {

    include systemd

    include user::supybot

    include python::virtualenv

    $supybotversion = '0.83.4.1'

    exec { 'checkout-supybot':
        command  => "/usr/bin/git clone git://git.code.sf.net/p/supybot/code /opt/supybot/code && cd /opt/supybot/code && git checkout v${supybotversion}",
        provider => shell,
        path     => [ '/bin', '/usr/bin' ],
        creates  => '/opt/supybot/code',
        user     => 'supybot',
        require  => File['/opt/supybot'],
    }

    exec { "make-supybot-virtualenv":
        command => "virtualenv --system-site-packages /opt/supybot",
        cwd     => "/opt/supybot",
        creates => "/opt/supybot/bin/pip",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        user    => 'supybot',
        require => [ File["/opt/supybot"], Package['python-virtualenv'] ],
    }

    exec { 'install-supybot':
        command => '/opt/supybot/bin/python setup.py install',
        cwd     => '/opt/supybot/code',
        path    => [ '/bin', '/usr/bin' ],
        user    => 'supybot',
        creates => '/opt/supybot/bin/supybot',
        require => [ Exec['make-supybot-virtualenv'],
                     Exec['checkout-supybot'], ],
    }

    file { '/etc/systemd/system/supybot.service':
        ensure => present,
        source => 'puppet:///modules/supybot/supybot.service',
        mode   => '0644',
        notify => [Service['systemd-reload'], Service['supybot']],
    }

    service { 'supybot':
        ensure     => running,
        hasrestart => false,
        require    => [ File['/etc/systemd/system/supybot.service'],
                        Exec['install-supybot'] ],
    }

}
