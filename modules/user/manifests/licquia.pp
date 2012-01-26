class user::licquia inherits user::virtual {

    realize(
        User['licquia'],
    )

    mailalias { 'licquia':
        ensure      => present,
        recipient   => 'licquia@linuxfoundation.org',
    }

    ssh_authorized_key { 'licquia@linuxfoundation.org':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDGFfywU/WIFTUmdWna2+3sX4aAmV6sdC2h36x9qDNDdYHwfaAJwBgoyx64D2d4YqTpR1+gF7G1vlPQngnodGdiMqeisRNkP8DHiDShzNDzhycFObeHv5/LwTVfL9PqwRHdTKmkhwM6ZkipFGq9F6GOMw0apAjGDNN/Q6SI9dDxTdj63J5TdN8GoIhtFwsQuGIojSQutqnhEDNj7CKVHGGy875SRyQAGfKar3D1bceAffZVgJKwnINyur8PtgGs2yBZnLPu5c7/tuvWzVO9KW5AJQqFknTTyD2/BvClAGSpJBZS6CadgIy/WseJYVH9GnmgB3v3ibXJcvn2+UVuqx15',
        user    => 'licquia',
    }

}
