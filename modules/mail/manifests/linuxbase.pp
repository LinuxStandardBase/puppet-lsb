# Settings for hosts that handle base level linuxbase.org mail.

class mail::linuxbase inherits mail::postfix {

    mailalias { 'gpg':
        recipient => 'lsb-discuss@lists.linux-foundation.org',
    }

    mailalias { 'buildbot':
        recipient => 'licquia@linuxfoundation.org',
    }

}
