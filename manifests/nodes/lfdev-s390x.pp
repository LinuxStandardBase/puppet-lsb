node 'etpglr3.dal-ebis.ihost.com' {

    include user::lfadmin, user::licquia, user::stewb, user::mats

    include sudo

    include puppet

    include buildbot::slavechroot

    # These are special entries for monitoring workload on the IBM server.

    cron { 's390x-weekly-work-report':
        command => '/opt/wureport/wureport $(date +%m/01/%y) $(date +%m/%d/%y) | mail -s "Weekly work report for lfdev-s390x" licquia@linuxfoundation.org',
        hour    => '20',
        minute  => '0',
        weekday => 'Monday',
    }

    cron { 's390x-monthly-work-report':
        command  => '/opt/wureport/wureport $(date -d "1 month ago" +%m/%d/%y) $(date +%m/%d/%y) | mail -s "Monthly work report for lfdev-s390x" licquia@linuxfoundation.org',
        hour     => '5',
        minute   => '0',
        monthday => '1',
    }

}
