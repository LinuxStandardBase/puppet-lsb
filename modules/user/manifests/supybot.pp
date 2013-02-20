class user::supybot inherits user::virtual {

    realize( User['supybot'] )

    file { '/opt/supybot':
        ensure => directory,
        owner  => 'supybot',
    }

}
