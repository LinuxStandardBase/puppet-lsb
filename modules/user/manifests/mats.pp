class user::mats inherits user::virtual {

    realize(
        User['mats'],
    )

    mailalias { 'mats':
        ensure      => present,
        recipient   => 'mats@linuxfoundation.org',
    }

    ssh_authorized_key { 'mats@linuxfoundation.org':
        ensure  => present,
        user    => 'mats',
        # Pick the correct type (first word in the public key file).
        type    => 'ssh-rsa',
        #type    => 'ssh-dss',
        # Paste key between the quotes (the gobbledygook w/o the type or id)
        key     => '',
        # Delete the following line once the ssh key has been added.
        noop    => true,
    }

}
