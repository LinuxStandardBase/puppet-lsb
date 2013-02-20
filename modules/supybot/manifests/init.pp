class supybot {

    include user::supybot

    $supybotversion = '0.83.4.1'

    exec { 'checkout-supybot':
        command  => "/usr/bin/git clone git://git.code.sf.net/p/supybot/code /opt/supybot/code && cd /opt/supybot/code && git checkout v${supybotversion}",
        provider => shell,
        path     => [ '/bin', '/usr/bin' ],
        creates  => '/opt/supybot/code',
        user     => 'supybot',
    }

}
