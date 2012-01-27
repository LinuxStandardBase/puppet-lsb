class user::lfadmin inherits user::virtual {

    realize(
        User['lfadmin'],
    )

    mailalias { 'lfadmin':
        ensure      => present,
        recipient   => 'root',
    }

    ssh_authorized_key { 'eric@linuxfoundation.org':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCsQDo1VbGN5xrpT5nxZ/KCf1f1fgekvh1XK8CymAhrp0WDfBWv/A1fnfrvwA4I81BaFmTb9zt+tObmpOKdhLUaTEQPN5ev5tOuEdpXOAHa3uTXathW6g7jPOLLmg3mH04iLYn7E/1q0YQ3qeAZfra/rGA5RwBxNZPJF8Lo8XtUjX8qYl4XORoPsUk/yOKnnoANRpFt8BqnwheRsrPMAApEZ9G4qKObq3ZJo+lVfb8IcFMulGPZG7ef2FTGsaRDaNxjxSQO0Y2jDqK/5eC+c9MvoNZfiUjlwyMDrQU8sTEWG3if+pbxL6eoQg7RQUyh2v10g0bYTnD5guni8HbWKtCUEoCk9wvhXH2V9XU+qxPbafBYa4VNNifL6eJ8vWCTRxj1mKiiZKcJZZxSbLY6Uo6QQ9KjBiGf7kuEUE8tzdeaYfUAIxoe44D0qD28pgpTWvBOh7Goio/l2g+bxbNCh9+2oR7p0///bQnUZUD9Od9eTcYRZ5wRnP57VncnfWT2j64DUll6ce4qVqonAb7T+QSRV7ppj9GoA5ksamjfBKR5FU1LgVuyMX2CirKdgGqkzW7DfTIlcelAoBArU504l/wmeR/kpzg2Yb5J+JxDXZMQCPH09As1wBNPEf/gUBQVt3AJwQEUfbEWQlrH8LF6/uBp6O3enpbuB5Ns8KTKgPB8xw==',
        user    => 'lfadmin',
    }

    ssh_authorized_key { 'licquia@lfsecure':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDGFfywU/WIFTUmdWna2+3sX4aAmV6sdC2h36x9qDNDdYHwfaAJwBgoyx64D2d4YqTpR1+gF7G1vlPQngnodGdiMqeisRNkP8DHiDShzNDzhycFObeHv5/LwTVfL9PqwRHdTKmkhwM6ZkipFGq9F6GOMw0apAjGDNN/Q6SI9dDxTdj63J5TdN8GoIhtFwsQuGIojSQutqnhEDNj7CKVHGGy875SRyQAGfKar3D1bceAffZVgJKwnINyur8PtgGs2yBZnLPu5c7/tuvWzVO9KW5AJQqFknTTyD2/BvClAGSpJBZS6CadgIy/WseJYVH9GnmgB3v3ibXJcvn2+UVuqx15',
        user    => 'lfadmin',
    }

    ssh_authorized_key { 'agrimberg@linuxfoundation.org':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCdH87x3wrYEJmW4vNr/2wdJFGI8VlgIQYMu0kZtVV5CuHMSvpULbgEr44q2YuX+fIznWfsXWMJrvbkGq72f3Kb1o3g4e40AQgtDD6mV7R6SPMsQ5oIchM5OO0rT/j18ry61NY+5qC+0ru05NNKlckJPkjwQQx1mHeC7/Rs29+LaRGhUDPE2tNOi1kMMKljrK0LFQ43Gmy8awNEXkr3XzyHeoiiBsp9l07NxQLwGk/OC6XrNjGpAbZ5Oo97YnhPYmQbKNAPGJ7cpHwtsDTGWGuqHSq/UgyCMUeWAUJwdOz1NC2PPnutPZ5gHPnxpYm3gUkfSL9af7pZ8MEp2j2NE0IP',
        user    => 'lfadmin',
    }

}
