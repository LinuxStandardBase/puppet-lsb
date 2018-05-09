class puppet::server inherits puppet {

    package { 'puppet-server':
        ensure  => $puppetmasterversion,
    }

    # For the Puppet server, puppet.conf is in the root of
    # this repository, and we don't want to override it
    # with the default client file.
    File['puppet.conf'] { source => undef }

    # Config auto-update, based on email notifications.
    # Requires that sudo be configured to allow the MTA user
    # to run "/usr/bin/bzr update -q" as root.

    #file { '/usr/local/bin/puppet-email-notify':
    #    source => [ "puppet:///modules/puppet/puppet-email-notify" ],
    #    mode => '0755',
    #}

    #mailalias { 'puppet-notify':
    #    recipient => '|/usr/local/bin/puppet-email-notify',
    #}

    # Disabled the email auto-update feature; instead, while we
    # migrate from lsb1 to lsb2, just do an update via cron
    # every few minutes, like with puppet-secret.

    cron { 'update-puppet':
        command => 'cd /etc/puppet && git pull -q',
        user    => 'root',
        minute  => '*/5',
    }

    # Update the secrets repository as well.  This is assumed to be
    # checked out to /etc/puppet-secret; this is a manual step
    # for setting up a puppet master.

    cron { 'update-puppet-secret':
        command => 'cd /etc/puppet-secret && git pull -q',
        user    => 'root',
        minute  => '*/5',
    }

    # Report on agent health.

    file { '/usr/local/bin/puppet-agent-health-report':
        source => [ "puppet:///modules/puppet/puppet-agent-health-report" ],
        mode => '0755',
    }

    cron { 'report-puppet-agent-health':
        command => '/usr/local/bin/puppet-agent-health-report',
        user    => 'root',
        minute  => 0,
        hour    => '*/3',
    }
}
