class user::herrold inherits user::virtual {

    realize(
        User['herrold'],
    )

    mailalias { 'herrold':
        ensure      => present,
        recipient   => 'herrold@owlriver.com',
    }

    # No SSH key yet!

}
