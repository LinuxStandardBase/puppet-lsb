# Top-level Puppet site configuration file.

# Global settings.

Mailalias { notify => Exec['newaliases'] }

exec { newaliases:
    path => [ '/usr/bin', '/usr/sbin' ],
    refreshonly => true,
}

# Import node configuration.
import 'nodes'

# Fix warnings about allow_virtual.
if versioncmp($::puppetversion,'3.6.1') >= 0 {

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}
