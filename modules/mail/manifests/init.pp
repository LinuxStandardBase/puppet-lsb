# Settings that apply to all hosts dealing with mail in or out

class mail {

    $mailrelay = 'lf-smtp2'

    package { 'mailx':
        ensure => present,
    }

    service { 'mtadaemon':
        enable => true,
        # This needs to be overriden
        name   => undef,
    }

}
