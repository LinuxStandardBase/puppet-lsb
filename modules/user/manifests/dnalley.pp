class user::dnalley inherits user::virtual {

    realize(
        User['dnalley'],
    )

    mailalias { 'dnalley':
        ensure      => present,
        recipient   => 'dnalley@linuxfoundation.org',
    }

    ssh_authorized_key { 'ke4qqq@nalleyt61.keymark.dom':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAtqqDXzCNpuQvr3yJa1XbhHDTW/hRwGMZCbninWxwWsd/E7QkuCdstBT2iGihbizbZlnh0mchjtvhouIADkbCyizvtRdujl0Vi1pg5i6YOKKkFc5/s2BRoqsrj0FLu7d2/oHddOz2DO1B8nfGfVyC9mxcqKVpOaGqfdcalLrAH60e7MmH9FkrEVMHQIgGaq1J9W0FFczcxrsCEu5FxXaFTGEos1BmnnsrdtCmQhSJ2n41cngZxrj+yy/HJSj++aDJ2HCwyvRnOX6PX7iNtLyRDX947+A4VbCRQtAC7IbccKHvTGTHSzBXs6PUNUEleZi5VHA6Xm4ubVNiNLwmGYlthw==',
        user    => 'dnalley',
    }

}
