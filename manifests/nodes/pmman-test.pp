# Test VM on Russ Herrold's network.
node 'vm178231179.pmman.net' {

    include user::lfadmin, user::licquia

    include sudo

    include puppet

    include sobby

}
