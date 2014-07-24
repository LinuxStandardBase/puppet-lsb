# Settings for hosts that handle base level linuxbase.org mail.

class mail::linuxbase inherits mail::postfix {

    mailalias { 'gpg':
        recipient => 'lsb-discuss@lists.linux-foundation.org',
    }

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
