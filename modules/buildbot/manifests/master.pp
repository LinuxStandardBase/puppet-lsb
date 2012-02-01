class buildbot::master inherits buildbot {

    include buildbotpw

    exec { "make-buildbot":
        command => "/opt/buildbot/bin/pip install buildbot==$buildbotversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lib/python$pythonversion/site-packages/buildbot-$buildbotversion-py$pythonversion.egg-info",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin" ],
        require => Exec["make-buildbot-virtualenv"],
    }

    exec { "make-buildbot-config":
        command => "bzr checkout http://bzr.linuxfoundation.org/lsb/devel/buildbot-config",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/buildbot-config",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => File["/opt/buildbot"],
    }

    file { "/opt/buildbot/lsb-master":
        ensure => directory,
        owner  => 'buildbot',
    }

    exec { "make-master":
        command => "/opt/buildbot/bin/buildbot create-master /opt/buildbot/lsb-master",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lsb-master/buildbot.tac",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin" ],
        user    => 'buildbot',
        require => [ Exec["make-buildbot"], File["/opt/buildbot/lsb-master"] ],
    }

    file { "/opt/buildbot/lsb-master/master.cfg":
        ensure  => link,
        target  => "../buildbot-config/lsb_master.cfg",
        require => [ Exec['make-buildbot-config'], Exec['make-master'] ],
    }

    file { "/opt/buildbot/lsb-master/bzr_buildbot.py":
        ensure  => link,
        target  => "../buildbot-config/bzr_buildbot.py",
        require => [ Exec['make-buildbot-config'], Exec['make-master'] ],
    }

    file { "/opt/buildbot/lsb-master/lfbuildbot.py":
        ensure  => link,
        target  => "../buildbot-config/lfbuildbot.py",
        require => [ Exec['make-buildbot-config'], Exec['make-master'] ],
    }

    exec { "make-htpasswd":
        command => "htpasswd -cb /opt/buildbot/htpasswd buildbot $buildbotpw::web",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        creates => '/opt/buildbot/htpasswd',
        require => File['/opt/buildbot'],
    }

    file { "/opt/buildbot/slave_pwds":
        mode    => 0400,
        owner   => 'buildbot',
        content => "lfbuild-x86_64:$buildbotpw::x64password
lfbuild-x86:$buildbotpw::x86password
lfbuild-ia64:$buildbotpw::ia64password
lfbuild-ppc32:$buildbotpw::ppc32password
lfbuild-ppc64:$buildbotpw::ppc64password
lfbuild-s390:$buildbotpw::s390password
lfbuild-s390x:$buildbotpw::s390xpassword
",
    }

    file { "/opt/buildbot/jobdir":
        ensure => directory,
        group  => 'users',
        owner  => 'buildbot',
        mode   => 0775,
    }

    file { "/etc/init.d/buildbot":
        ensure => present,
        source => "puppet:///modules/buildbot/buildbot.init",
        mode   => 0755,
        notify => Service['buildbot'],
    }

    service { "buildbot":
        ensure     => running,
        hasrestart => false,
        hasstatus  => false,
        require    => 
            [ File['/etc/init.d/buildbot'], File['/opt/buildbot/slave_pwds'], 
              File['/opt/buildbot/lsb-master/master.cfg'], 
              File['/opt/buildbot/lsb-master/lfbuildbot.py'], 
              File['/opt/buildbot/lsb-master/bzr_buildbot.py'],
              User['buildbot'], Exec['make-master'], Exec['make-htpasswd'] ],
    }

}
