Buildbot Setup
==============

Our buildbot setup happens in two places: here (under
modules/buildbot) and in the buildbot-config version control
repository.  Puppet is mostly concerned about the details of deploying
buildbot masters and slaves, while buildbot-config contains the
configuration and many of the maintenance tasks.

Slave Setup
-----------

Slave setup is mostly driven by the manifests in Puppet; just include
the following in the manifest for the host you want to be a build
slave:

    include buildbot::slave

The one complication comes with the architectures with "small" and
"big" word architectures, where the native hardware is almost all
"big".  This means we have to build the "small" architecture on a
"big" system.  On these architectures, we need to configure which word
size we're building.

This is done in modules/buildbot/manifests/slave.pp.  Look for the
setting for "$wordsize"; there, you will need to add the hostname of
the build slave and make sure it's set to "small" or "big".

Restarting Buildbot
-------------------

In general, restarting buildbot is a matter of running the init
script.

For slaves, this is easy:

    # service buildslave stop
    # service buildslave start

The buildbot master can be a little more complicated.  There's an init
script, but buildbot can sometimes get wedged and not shut down
cleanly.  In some cases, you'll need to 'kill -9' the buildbot
process.  (You can find it with ps, or use
/opt/buildbot/lsb-master/twistd.pid to get the process ID.)

The buildbot init script will check the configuration before starting
buildbot, and will refuse to start if the configuration doesn't check
out.

If you don't know where buildbot is currently hosted, look for the
line "include buildbot::master" in the per-host files in
manifests/nodes.
