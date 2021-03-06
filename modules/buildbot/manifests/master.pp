class buildbot::master inherits buildbot {

    include systemctl

    include buildbot::virtualenv

    include buildbotpw

    $sqlalchemyversion = '0.7.10'

    $buildbotconfigrev = '89edfaf'

    $weeklyrebuildarchs = 'x86,x86_64,ia64,ppc32,ppc64,s390,s390x'

    $htpasswd = "${operatingsystem}-${operatingsystemrelease}" ? {
        /^SLES-11(\.[0-9])?$/ => 'htpasswd2',
        /^OpenSuSE-13\.1$/    => 'htpasswd2',
        default               => 'htpasswd',
    }

    package { 'createrepo':
        ensure => present,
    }

    package { 'haskell-platform':
        ensure => present,
    }

    exec { "make-sqlalchemy":
        command => "/opt/buildbot/bin/pip install sqlalchemy==$sqlalchemyversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lib/python${pythonversion}/site-packages/SQLAlchemy-${sqlalchemyversion}-py${pythonversion}.dist-info",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin" ],
        require => Exec["make-buildbot-virtualenv"],
    }

    exec { "make-buildbot":
        command => "/opt/buildbot/bin/pip install --no-deps buildbot==$buildbotversion",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lib/python${pythonversion}/site-packages/buildbot-${buildbotversion}-py${pythonversion}.dist-info",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin" ],
        require => [ Exec["make-buildbot-virtualenv"],
                     Exec["make-sqlalchemy"] ],
    }

    exec { "make-buildbot-config":
        command => "git clone https://github.com/LinuxStandardBase/buildbot-config.git && cd buildbot-config && git checkout -q $buildbotconfigrev",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/buildbot-config",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => File["/opt/buildbot"],
    }

    file { "/opt/buildbot/lsb-master":
        ensure  => directory,
        owner   => 'buildbot',
        require => File["/opt/buildbot"],
    }

    file { "/opt/buildbot/debcache-snapshot":
        ensure  => directory,
        owner   => 'buildbot',
        require => File["/opt/buildbot"],
    }

    file { "/opt/buildbot/Maildir":
        ensure  => directory,
        owner   => 'buildbot',
        group   => 'users',
        mode    => '0700',
        require => File["/opt/buildbot"],
    }

    file { "/opt/buildbot/Maildir/cur":
        ensure  => directory,
        owner   => 'buildbot',
        group   => 'users',
        mode    => '0700',
        require => File["/opt/buildbot/Maildir"],
    }

    file { "/opt/buildbot/Maildir/new":
        ensure  => directory,
        owner   => 'buildbot',
        group   => 'users',
        mode    => '0700',
        require => File["/opt/buildbot/Maildir/cur"],
    }

    file { "/opt/buildbot/Maildir/tmp":
        ensure  => directory,
        owner   => 'buildbot',
        group   => 'users',
        mode    => '0700',
        require => File["/opt/buildbot/Maildir/new"],
    }

    file { "/opt/buildbot/debcache-snapshot/pkgs-snapshot":
        ensure  => directory,
        owner   => 'buildbot',
        require => File["/opt/buildbot/debcache-snapshot"],
    }

    exec { "make-master":
        command => "/opt/buildbot/bin/buildbot create-master /opt/buildbot/lsb-master",
        cwd     => "/opt/buildbot",
        creates => "/opt/buildbot/lsb-master/buildbot.tac",
        path    => [ "/opt/buildbot/bin", "/bin", "/sbin", "/usr/bin",
                     "/usr/sbin" ],
        user    => 'buildbot',
        require => [ Exec["make-buildbot"], Exec["make-buildbot-config"],
                     File["/opt/buildbot/lsb-master"] ],
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

    file { "/opt/buildbot/lsb-master/templates":
        ensure  => link,
        target  => "../buildbot-config/templates",
        force   => true,
        require => [ Exec['make-buildbot-config'], Exec['make-master'] ],
    }

    file { "/opt/buildbot/lsb-master/public_html":
        ensure  => link,
        target  => "../buildbot-config/public_html",
        force   => true,
        require => [ Exec['make-buildbot-config'], Exec['make-master'] ],
    }

    exec { "make-htpasswd":
        command => "$htpasswd -cb /opt/buildbot/htpasswd buildbot $buildbotpw::web",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        creates => '/opt/buildbot/htpasswd',
        require => File['/opt/buildbot'],
    }

    file { "/opt/buildbot/slave_pwds":
        mode    => '0400',
        owner   => 'buildbot',
        content => "lfbuild-x86_64:$buildbotpw::x64password
lfbuild-x86:$buildbotpw::x86password
lfbuild-ia64:$buildbotpw::ia64password
lfbuild-ppc32:$buildbotpw::ppc32password
lfbuild-ppc64:$buildbotpw::ppc64password
lfbuild-s390:$buildbotpw::s390password
lfbuild-s390x:$buildbotpw::s390xpassword
devchk-fedora-x86:$buildbotpw::x86fedora
devchk-fedora-x86_64:$buildbotpw::x64fedora
",
    }

    file { "/opt/buildbot/jobdir":
        ensure => directory,
        group  => 'users',
        owner  => 'buildbot',
        mode   => '0775',
    }

    file { '/etc/systemd/system/buildbot.service':
        ensure => present,
        source => 'puppet:///modules/buildbot/buildbot.service',
        mode   => '0644',
        notify => [Exec['systemd-reload'], Service['supybot']],
    }

    file { "/usr/local/bin/start_lsb_build":
        ensure => link,
        target => "/opt/buildbot/buildbot-config/cmdline/start_lsb_build",
    }

    service { "buildbot":
        ensure     => running,
        hasrestart => false,
        hasstatus  => false,
        require    => 
            [ File['/etc/systemd/system/buildbot.service'],
              File['/opt/buildbot/slave_pwds'],
              File['/opt/buildbot/lsb-master/master.cfg'],
              File['/opt/buildbot/lsb-master/lfbuildbot.py'],
              File['/opt/buildbot/lsb-master/bzr_buildbot.py'],
              File['/opt/buildbot/Maildir/tmp'],
              User['buildbot'], Exec['make-master'], Exec['make-htpasswd'] ],
    }

    cron { 'update-snapshot':
        command => '/opt/buildbot/buildbot-config/update-snapshot',
        user    => 'root',
        minute  => '*/5',
        require => Exec['make-buildbot-config'],
    }

    cron { 'weekly-rebuild':
        command => "echo architectures=$weeklyrebuildarchs | cat /opt/buildbot/buildbot-config/weekly-jobfile - > /opt/buildbot/jobdir/weekly-jobfile",
        user    => 'buildbot',
        hour    => '1',
        minute  => '0',
        weekday => 'Saturday',
    }

    cron { 'weekly-rebuild-devchk':
        command => '/usr/local/bin/start_lsb_build devel devchk',
        user    => 'buildbot',
        hour    => '1',
        minute  => '0',
        weekday => 'Saturday',
    }

    cron { 'daily-low-resource-jobs':
        command => '/opt/buildbot/buildbot-config/low-resource-jobs',
        user    => 'buildbot',
        hour    => '19',
        minute  => '30',
    }

    exec { 'update-buildbot-config':
        command => "git fetch -q && git checkout -q $buildbotconfigrev",
        cwd     => "/opt/buildbot/buildbot-config",
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        require => Exec['make-buildbot-config'],
    }

}
