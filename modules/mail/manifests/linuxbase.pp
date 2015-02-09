# Settings for hosts that handle base level linuxbase.org mail.

class mail::linuxbase inherits mail::postfix {

    # Site admin email.  Use 'root' as the alias for everything
    # else, and point 'root' at the proper site admin alias.

    mailalias { 'root':
        recipient => 'licquia@linuxfoundation.org',
    }

    mailalias { 'hostmaster':
        recipient => 'root',
    }

    # Destination for inquiries related to signed packages
    # or repositories.

    mailalias { 'gpg':
        recipient => 'lsb-discuss@lists.linux-foundation.org',
    }

    # Support aliases.

    mailalias { 'lsb-dtk-support':
        recipient => 'lsb-discuss@lists.linux-foundation.org',
    }

    mailalias { 'lsb-appchk-support':
        recipient => 'lsb-discuss@lists.linux-foundation.org',
    }


    # The following alias is necessary whenever mail is handled
    # on a separate host from the buildbot master.  Switch the
    # ensure line to 'absent' or 'present' depending on whether
    # it's needed.

    mailalias { 'buildbot':
        ensure    => absent,
        recipient => 'buildbot@lsb1.linux-foundation.org',
    }

}
