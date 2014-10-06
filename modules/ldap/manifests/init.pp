class ldap {

    file { '/etc/openldap/ldap.conf':
        source => 'puppet:///modules/ldap/ldap.conf',
    }

}
