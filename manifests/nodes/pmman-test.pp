# Test VM on Russ Herrold's network.
node 'vm178231179.pmman.net' {

    include user::licquia

    include sudo

    include puppet

}
