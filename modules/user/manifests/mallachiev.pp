class user::mallachiev inherits user::virtual {

    realize(
        User['mallachiev'],
    )

    mailalias { 'mallachiev':
        ensure      => present,
        recipient   => 'mallachiev@ispras.ru',
    }

    ssh_authorized_key { 'kurban@bordos':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDKy0y7+756SL+/9VqVy6faUL/iQPEJ83Zr9frgsS83+FEVxosBvMLKzNwYAKS4ukLJE6eNP0EFGUUXR6pH9RJXF1ledEWRj5vJQK4ke2BDuzX+WjVduKJJAjDj//ALTKNyZ4a63ioDkF7PdYrRmc+hiZDoXggPfq7beogu/Hza3sUBI000h/7FV4T1P7+lMuEFP3hqtitmBBu8xmmiaD5rIDcRcjSor3Ds8mA1hVubDKqfzkWaY4X0BciZbSEsseWUcPncVXhXtql0Do03viNqMjGkXXzAmqppTzsaZ8jT5D28l0TRETcoag17X0b87gabBCZlMEhDQpM8z8PkVIFT',
        user    => 'mallachiev',
    }

}
