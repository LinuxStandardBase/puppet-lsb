# Test VM on Russ Herrold's network.
node 'vm178231236.pmman.net' {

    include user::licquia

    include sudo

    include puppet

}
