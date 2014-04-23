New User Policies
=================

In general, we only grant user accounts to active and trusted
workgroup members.  If you have the ability to edit the Puppet config,
you can assume we trust you well enough.  Otherwise, anyone who wants
a user account should ask a current workgroup member to sponsor them.

It's also important to not create users on machines just for the heck
of it.  Unused accounts on machines are security problems.  It's
generally a good idea to remove your user account from a machine
you're not using at the moment.  You can always add it back via Puppet
later (or have a workgroup person add it for you).

Adding a User
-------------

To add a user, first edit modules/user/manifests/virtual.pp, and
create a virtual user profile for yourself.  This will include the
basic information about the account.

A typical user will look like this:

    @user { 'joeuser':
        ensure      => present,
        gid         => 'users',
        comment     => 'Joe User',
        home        => '/home/joeuser',
        shell       => '/bin/bash',
        managehome  => true,
    }

If your user account needs to be different than this (for example, if
you don't want 'managehome' set for some reason), please discuss with
the rest of the workgroup.

Next, you'll want to create a user-specific manifest.  Name it with
your chosen username, such as "herrold.pp".  You'll want to realize
the virtual user you already defined, set a mail alias, and add a SSH
key, and inherit from user::virtual.  So:

    class user::joeuser inherits user::virtual {

        realize(User['joeuser'])

        mailalias { 'joeuser':
            ensure    => present,
            recipient => 'joeuser@example.com',
        }

        ssh_authorized_key { 'joeuser@myhost':
            ensure => present,
            type   => 'ssh-rsa',
            key    => 'long-string-of-encoded-stuff',
            user   => 'joeuser',
        }

    }

Superuser Access
----------------

We don't have any special support for declaring superuser status in
Puppet, so simply edit the appropriate file in
modules/sudo/files/sudoers/{hostname}.

Occasionally, we've had problems with Puppet not updating sudoers
files in the past.  If sudo continues to not work for you for a
reasonable time after committing the sudoers changes (about an hour
should be long enough), contact a member of the workgroup to get
manual assistance.
