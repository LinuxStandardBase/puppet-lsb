class mail::postfix inherits mail {

    include make

    package { 'postfix':
        ensure => present,
        before => Service['postfix'],
    }

    Service['postfix'] {
        enable => true,
    }

    file { '/etc/postfix':
        ensure  => directory,
        recurse => true,
        recurselimit => 1,
        source  => [ "puppet:///modules/mail/postfix/$fqdn", "puppet:///modules/mail/postfix/${domain}_relay_to_${mailrelay}" ],
        notify  => Exec['make-etc-postfix'],
    }

    exec { 'make-etc-postfix':
        command     => '[ -f /etc/postfix/Makefile ] && make -C /etc/postfix || true',
        path        => [ '/usr/sbin', '/usr/bin', '/bin' ],
        refreshonly => true,
        logoutput   => true,
        notify      => Service['postfix'],
    }

}
