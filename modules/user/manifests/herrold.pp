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
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAuBgHhm6RzKd2MUJLv2G36PVi7fgH+haefHQRH1ZCPv4FHbDuKLHJr2T6JrrzUCPnlX7wXNGTJPlAmiw8mfM4eTdgybjXE4Htj9CewyPP8hzOSc3bxQD4UgdPGy0XsxHQg3weAg1+/K5iXpYMLsrsF2yub9xZ9+0FuXFMkVq2W0AbOoUF+2DX5e461RfZkFxtUjcKZNHgFtPhwzcVMmQVj+96m28jJFnDCWJI5vcUoMIf3VnH4XX757jNOj+KX87eE7q4hUhkn7GZ0k2/nkDKsh3Ey01IvxLsjquf4wVN5T3ESk3EAgtSlq6XfbK90POZqtYIz5g/bDT8QOyRu9SMjw==',
        user    => 'herrold',
    }



}
