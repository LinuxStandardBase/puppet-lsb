class user::herrold inherits user::virtual {

    realize(
        User['herrold'],
    )

    mailalias { 'herrold':
        ensure      => present,
        recipient   => 'herrold@owlriver.com',
    }

    # No SSH key yet! -- delete this line once we get a successful commit at the master
    ssh_authorized_key { 'herrold+lf-2013-rsa@owlriver.com':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA7q203HceYQBUBzJSpp6IP0aIfH8PLLbqYdRM38u5X/W0P+r2gYIq7hr2R4+wYvCZvySXoA3dukrI/V/bTsF5W++h2LTtFNZvSTZYbv/ZDFfe9QlOEamY+kKZkgvOByZiOJhv4jnxIY1IUmSQHdy0CWjA82VMncaTm3vOkg+565SIhFAgxLxu/UhH7IK66IEreefAx5qFVF4O6jU3kKKzUZaimqXwIJuZvce52l8qc6zZyLobuEqTPv5mwLSH8LbZKlf/N5jWJJ1Ou1p8tZB4BZbeJv8FP4cHVMyHf9EJUkKKdeQiI2N8X8c4zy+Kqc/+kXf5I1UcwyOsLAFOTlfQsw==',
        user    => 'herrold',
    }



}
