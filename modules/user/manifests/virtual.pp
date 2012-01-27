# Users are declared here as virtual, and then realized for
# individual user classes.
class user::virtual inherits user {

    @user { 'lfadmin':
        ensure      => present,
        uid         => '1000',
        comment     => 'Linux Foundation IT',
        home        => '/home/lfadmin',
        shell       => '/bin/bash',
        managehome  => true,
    }

    @user { 'licquia':
        ensure      => present,
        uid         => '1001',
        gid         => '100',
        comment     => 'Jeff Licquia',
        home        => '/home/licquia',
        shell       => '/bin/bash',
        managehome  => true,
    }

    @user { 'stewb':
        ensure      => present,
        uid         => '1002',
        gid         => '100',
        comment     => 'Stew Benedict',
        home        => '/home/stewb',
        shell       => '/bin/bash',
        managehome  => true,
    }

    @user { 'mats':
        ensure      => present,
        uid         => '1003',
        gid         => '100',
        comment     => 'Mats Wichmann',
        home        => '/home/mats',
        shell       => '/bin/bash',
        managehome  => true,
    }

}
