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
    # on a separate host from the buildbot master.  As of now,
    # this is true during the lsb1 -> lsb2 migration.

    mailalias { 'buildbot':
        recipient => 'buildbot@lsb1.linux-foundation.org',
    }

}
