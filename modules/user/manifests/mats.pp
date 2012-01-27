class user::mats inherits user::virtual {

    realize(
        User['mats'],
    )

    mailalias { 'mats':
        ensure      => present,
        recipient   => 'mats@linuxfoundation.org',
    }

    ssh_authorized_key { 'mats@linuxfoundation.org':
        ensure  => present,
        user    => 'mats',
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDCLtvB4thaICbb/smVwnDeCOrcVjyWmU7mqzQrUvk+vhhWa/eQknVnQIu035PoK5/luaVJZypv2s4rN31ckhi1QPhej9paM83ANYdzwvzJ7IAZomztRhnbqGlsVLSbl0nnym4FV1iv/pIbp0UcbDyY+0dQ3pe5Noo1+oMAoxv/bDRk4YwTeEBv1H7Us+7aDXgerWTOLS07ck3OC5Acg9nQ0SUwDh/YmW0IkZMLjlH1INIEoYaNoXUI7ujdlNdk6ojUH8R1KiP2kaJeIN1j6Jd1RK5zJ40rdvq/NUDPuht42eGV8oE/Nf9wVL+AFJJexGWaFgjlHt2mBe6ENbkr6dsj',
    }

}
