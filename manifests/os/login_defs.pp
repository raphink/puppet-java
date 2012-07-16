class generic-tmpl::os::login_defs {
  augeas {'Set first and last uids':
    context => '/files/etc/login.defs',
    changes => [
      'set UID_MIN 1000',
      'set UID_MAX 60000',
    ],
  }
}
