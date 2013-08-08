# Users are declared here as virtual, and then realized for
# individual user classes.
class user::virtual inherits user {

    @user { 'buildbot':
        ensure      => present,
        home        => '/opt/buildbot',
    }

    @user { 'supybot':
        ensure      => present,
        home        => '/opt/supybot',
    }

    @user { 'lfadmin':
        ensure      => present,
        comment     => 'Linux Foundation IT',
        home        => '/home/lfadmin',
        shell       => '/bin/bash',
        managehome  => true,
    }

    @user { 'licquia':
        ensure      => present,
        gid         => 'users',
        comment     => 'Jeff Licquia',
        home        => '/home/licquia',
        shell       => '/bin/bash',
        managehome  => true,
    }

    @user { 'stewb':
        ensure      => present,
        gid         => 'users',
        comment     => 'Stew Benedict',
        home        => '/home/stewb',
        shell       => '/bin/bash',
        managehome  => true,
    }

    @user { 'mats':
        ensure      => present,
        gid         => 'users',
        comment     => 'Mats Wichmann',
        home        => '/home/mats',
        shell       => '/bin/bash',
        managehome  => true,
    }

    @user { 'herrold':
        ensure      => present,
        gid         => 'users',
        comment     => 'R P Herrold',
        home        => '/home/herrold',
        shell       => '/bin/bash',
        managehome  => true,
    }

    @user { 'mallachiev':
        ensure      => present,
        gid         => 'users',
        comment     => 'Kurban Mallachiev',
        home        => '/home/mallachiev',
        shell       => '/bin/bash',
        managehome  => true,
    }

}
