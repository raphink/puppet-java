class generic-tmpl::os::login_defs {
  augeas {'Set first and last uids':
    incl    => '/etc/login.defs',
    lens    => 'Login_Defs.lns',
    changes => [
      'set UID_MIN 1000',
      'set UID_MAX 60000',
    ],
  }

  Augeas['Set first and last uids'] -> User <| |>
  Augeas['Set first and last uids'] -> Group <| |>
  Augeas['Set first and last uids'] -> Package <| |>
}
