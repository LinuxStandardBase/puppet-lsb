class user::stewb inherits user::virtual {

    realize(
        User['stewb'],
    )

    mailalias { 'stewb':
        ensure      => present,
        recipient   => 'stewb@linuxfoundation.org',
    }

    ssh_authorized_key { 'stew@pavilion.e-artisan.org':
        ensure  => present,
        type    => 'ssh-dss',
        key     => 'AAAAB3NzaC1kc3MAAACBAKYW5pKhw/Duu2zuqOhNwPotLD6BT8NYiN5nx5mVL9UPECgz6dlPIM4QNf1CKnPxAKlozXz4l9moDo8Yn7rz/PAhv4UBjRzJnINVm60dY7OOKSSZE4otzRqtaZ8/eF7ntJVhxIAyJ8Zng1X63joM32hBsm5xW5wrkUTkcgq+7oOdAAAAFQC9JYXbMWOHeNUk9Jj7rD0mFYZZsQAAAIAc/JwZ5bAvB0nJSjmiHhisfczRyNbU9WiJz0mRHqIFRxmNsfbFBsp60J+8NyHy4ISyVvhZGPxsIikiVM5cdjnwIZGtRr6YxTc+VWRB5FzREjGPA6Ix5v+tMkDMCHMy1kC76FfLLTizXa5/deAGwRveaGwH8vxmnYucGe3rU71BowAAAIEAkYnRJ6ctRMx4Qqzcvcy9KxTlIjAGcZUlIG1dn0CZK7PBNTHEG102nRez6rXCP5ARFVjCvfrezvFBC8yUYc/QAi73M9XMxti80rE2hEx702kHB4aHjTeya3nlvNJudKtc1K7FkVEvDr7Sbcsfu9MIJ2+Vfd1oXps9W/yOZunB4wM=',
        user    => 'stewb',
    }

}
