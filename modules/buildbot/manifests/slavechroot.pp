class buildbot::slavechroot inherits buildbot {

    include buildbotpw

    # Build slaves using this configuration do builds in chroots:
    # one each for the 31/32-bit and 64-bit variants of that arch.
    # For now, the chroots have to be unpacked manually.  Here, we
    # configure the chroot paths.

    $smallwordchroot = $hostname ? {
        'etpglr3' => '/data/chroots/sles11-31bit',
        'pmac'    => '/data/chroots/sles11-32bit',
    }

    $bigwordchroot = '/data/chroots/sles11-64bit'

    # Set the location for the real gcc/ld.

    $realgcc = '${0##/*/}-4.3'

    $realld = '/usr/bin/ld.REAL'

    # We need to force small-word builds on the small-word chroots.
    # NOTE: these are also defined in slave.pp; make sure that they
    # get changed in both places if they need to change.

    $smallwordarch = $architecture ? {
        's390x' => 's390',
        'ppc64' => 'ppc',
    }

    $gccsmallword = $architecture ? {
        's390x' => '-m31',
        'ppc64' => '-m32',
    }

    $ldsmallword = $architecture ? {
        's390x' => '-melf_s390',
        'ppc64' => '-melf32ppc',
    }

    # Within a chroot, we do the chroot setup by copying a
    # Puppet config into it and using "puppet apply" to apply
    # it.  We do this b/c the Puppet master/agent setup
    # doesn't handle chroots well; nodes are identified
    # by FQDN, for example.

    file {
        '/etc/puppet-chroot': ensure => directory;
        '/etc/puppet-chroot/modules': ensure => directory;
        '/etc/puppet-chroot/modules/buildbot': ensure => directory;
        '/etc/puppet-chroot/modules/buildbot/manifests': ensure => directory;
        '/etc/puppet-chroot/modules/buildbot/files': ensure => directory;
        '/etc/puppet-chroot/modules/buildbot/templates': ensure => directory;
        '/etc/puppet-chroot/modules/buildbotpw': ensure => directory;
        '/etc/puppet-chroot/modules/buildbotpw/manifests': ensure => directory;
    }

    File['/etc/puppet-chroot'] -> File['/etc/puppet-chroot/modules']
    File['/etc/puppet-chroot/modules'] -> File['/etc/puppet-chroot/modules/buildbot']
    File['/etc/puppet-chroot/modules'] -> File['/etc/puppet-chroot/modules/buildbotpw']
    File['/etc/puppet-chroot/modules/buildbot'] -> File['/etc/puppet-chroot/modules/buildbot/manifests']
    File['/etc/puppet-chroot/modules/buildbotpw'] -> File['/etc/puppet-chroot/modules/buildbotpw/manifests']

    # These module files should be exactly the same as the buildbot
    # module manifests in regular Puppet.

    file { '/etc/puppet-chroot/modules/buildbot/manifests/init.pp':
        source  => 'puppet:///modules/buildbot/chroot/modules/buildbot/manifests/init.pp',
        require => File['/etc/puppet-chroot/modules/buildbot/manifests'],
    }

    file { '/etc/puppet-chroot/modules/buildbot/manifests/slavepkgs.pp':
        source  => 'puppet:///modules/buildbot/chroot/modules/buildbot/manifests/slavepkgs.pp',
        require => File['/etc/puppet-chroot/modules/buildbot/manifests'],
    }

    file { '/etc/puppet-chroot/modules/buildbot/manifests/slave.pp':
        source  => 'puppet:///modules/buildbot/chroot/modules/buildbot/manifests/slave.pp',
        require => File['/etc/puppet-chroot/modules/buildbot/manifests'],
    }

    file { '/etc/puppet-chroot/modules/buildbot/manifests/virtualenv.pp':
        source  => 'puppet:///modules/buildbot/chroot/modules/buildbot/manifests/virtualenv.pp',
        require => File['/etc/puppet-chroot/modules/buildbot/manifests'],
    }

    file { '/etc/puppet-chroot/modules/buildbot/templates/buildslave.init.erb':
        source  => 'puppet:///modules/buildbot/chroot/modules/buildbot/templates/buildslave.init.erb',
        require => File['/etc/puppet-chroot/modules/buildbot/templates'],
    }

    file { '/etc/puppet-chroot/modules/buildbot/files/slavescripts':
        ensure  => directory,
        source  => 'puppet:///modules/buildbot/slavescripts',
        recurse => true,
        require => File['/etc/puppet-chroot/modules/buildbot/files'],
    }

    file { '/etc/puppet-chroot/modules/buildbot/files/gcc-wrapper':
        content => template('buildbot/gcc-wrapper.erb'),
        require => File['/etc/puppet-chroot/modules/buildbot/files'],
    }

    file { '/etc/puppet-chroot/modules/buildbot/files/ld-wrapper':
        content => template('buildbot/ld-wrapper.erb'),
        require => File['/etc/puppet-chroot/modules/buildbot/files'],
    }

    # Other modules.  The way that works here: we link to the general
    # modules directory, and pull in modules explicitly here.

    file { '/etc/puppet-chroot/modules/user':
        ensure  => directory,
        source  => 'puppet:///modules/buildbot/chroot/modules/user',
        recurse => true,
    }

    file { '/etc/puppet-chroot/modules/python':
        ensure  => directory,
        source  => 'puppet:///modules/buildbot/chroot/modules/python',
        recurse => true,
    }

    file { '/etc/puppet-chroot/modules/bzr':
        ensure  => directory,
        source  => 'puppet:///modules/buildbot/chroot/modules/bzr',
        recurse => true,
    }

    file { '/etc/puppet-chroot/modules/sudo':
        ensure  => directory,
        source  => 'puppet:///modules/buildbot/chroot/modules/sudo',
        recurse => true,
    }

    # For password information, we mock up a buildbotpw module as
    # if from puppet-secrets, but we only include the appropriate
    # user info.

    $smallworduser = $architecture ? {
        's390x' => 'lfbuild-s390',
        'ppc64' => 'lfbuild-ppc32',
    }

    $smallwordpass = $architecture ? {
        's390x' => $buildbotpw::s390password,
        'ppc64' => $buildbotpw::ppc32password,
    }    

    $bigworduser = $architecture ? {
        's390x' => 'lfbuild-s390x',
        'ppc64' => 'lfbuild-ppc64',
    }

    $bigwordpass = $architecture ? {
        's390x' => $buildbotpw::s390xpassword,
        'ppc64' => $buildbotpw::ppc64password,
    }

    file { '/etc/puppet-chroot/modules/buildbotpw/manifests/init_smallword.pp':
        content => template('buildbot/buildbotpw-init-smallword.pp.erb'),
        mode    => '0600',
        require => File['/etc/puppet-chroot/modules/buildbotpw/manifests'],
    }

    file { '/etc/puppet-chroot/modules/buildbotpw/manifests/init_bigword.pp':
        content => template('buildbot/buildbotpw-init-bigword.pp.erb'),
        mode    => '0600',
        require => File['/etc/puppet-chroot/modules/buildbotpw/manifests'],
    }

    # Set up the chroots properly.

    mount { [ "$smallwordchroot/proc", "$bigwordchroot/proc" ]:
        ensure  => mounted,
        fstype  => 'proc',
        device  => 'proc',
        options => 'defaults',
    }

    # Actually apply the config to the chroot.

    exec { 'puppet-update-smallword-chroot':
        command   => "rsync -a /etc/puppet-chroot $smallwordchroot/tmp && ln -sf init_smallword.pp $smallwordchroot/tmp/puppet-chroot/modules/buildbotpw/manifests/init.pp && chroot $smallwordchroot puppet apply --modulepath=/tmp/puppet-chroot/modules -e '\$chroot = 'small' include buildbot::slave'",
        path      => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        logoutput => true,
    }

    exec { 'puppet-update-bigword-chroot':
        command   => "rsync -a /etc/puppet-chroot $bigwordchroot/tmp && ln -sf init_bigword.pp $bigwordchroot/tmp/puppet-chroot/modules/buildbotpw/manifests/init.pp && chroot $bigwordchroot puppet apply --modulepath=/tmp/puppet-chroot/modules -e '\$chroot = 'big' include buildbot::slave'",
        path      => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        logoutput => true,
    }

}
