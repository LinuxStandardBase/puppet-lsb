# Top-level Puppet site configuration file.

# Global settings.

Mailalias { notify => Exec['newaliases'] }

exec { newaliases:
    path => [ '/usr/bin', '/usr/sbin' ],
    refreshonly => true,
}

# Import node configuration.
import 'nodes'
