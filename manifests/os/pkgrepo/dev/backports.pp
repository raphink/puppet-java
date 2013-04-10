class generic-tmpl::os::pkgrepo::dev::backports {

  apt::sources_list {"c2c-${lsbdistcodename}-dev-backports":
    ensure  => present,
    content => "deb http://pkg.camptocamp.net/dev ${lsbdistcodename}-backports main contrib non-free",
    require => Apt::Key["5C662D02"],
  }

}
