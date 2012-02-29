# sudoers file.
#
# This file MUST be edited with the 'visudo' command as root.
# Failure to use 'visudo' may result in syntax or file permission errors
# that prevent sudo from running.
#
# See the sudoers man page for the details on how to write a sudoers file.
#

# Host alias specification

# User alias specification

# Cmnd alias specification

# Defaults specification

# Prevent environment variables from influencing programs in an
# unexpected or harmful way (CVE-2005-2959, CVE-2005-4158, CVE-2006-0151)
Defaults	always_set_home
Defaults	env_reset
# Change env_reset to !env_reset in previous line to keep all environment variables
# Following list will no longer be necessary after this change

Defaults	env_keep = "LANG LC_ADDRESS LC_CTYPE LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME LC_ALL LANGUAGE LINGUAS XDG_SESSION_COOKIE"
# Comment out the preceding line and uncomment the following one if you need
# to use special input methods. This may allow users to compromise  the root
# account if they are allowed to run commands without authentication.
#Defaults env_keep = "LANG LC_ADDRESS LC_CTYPE LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME LC_ALL LANGUAGE LINGUAS XDG_SESSION_COOKIE XMODIFIERS GTK_IM_MODULE QT_IM_MODULE QT_IM_SWITCHER"

# In the default (unconfigured) configuration, sudo asks for the root password.
# This allows use of an ordinary user account for administration of a freshly
# installed system. When configuring sudo, delete the two
# following lines:
#Defaults	targetpw
#ALL	ALL = (ALL) ALL   

# Runas alias specification

# User privilege specification
root	ALL = (ALL) ALL
lfadmin	ALL = (ALL) ALL 
licquia ALL = (ALL) ALL

# Buildbot: allow the buildbot user to install packages
buildbot ALL=NOPASSWD: /bin/rpm

