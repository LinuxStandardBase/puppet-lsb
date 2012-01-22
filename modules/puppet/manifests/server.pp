class puppet::server inherits puppet {

    package { 'puppet-server': ensure => $puppetversion; }

    # For the Puppet server, puppet.conf is in the root of
    # this repository, and we don't want to override it
    # with the default client file.
    File['puppet.conf'] { source => undef }

    # Config auto-update, based on email notifications.

    file { '/usr/local/bin/puppet-email-notify':
        source => [ "puppet:///modules/puppet/puppet-email-notify" ],
        mode => 0755,
    }

}
