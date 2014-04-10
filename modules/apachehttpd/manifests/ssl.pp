class apachehttpd::ssl {

    include tls

    file { '/etc/apache2/ssl.crt/linuxbase-sf_bundle.pem':
        content => "${tls::cert}${tls::sf_bundle_g2}",
    }

    file { '/etc/apache2/ssl.key/linuxbase.key':
        content => $tls::key,
        mode    => 0600,
        owner   => 'root',
        group   => 'root',
    }

}
