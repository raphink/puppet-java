class generic-tmpl::os::pkgrepo::dev::sysadmin {

  apt::sources_list {"c2c-${lsbdistcodename}-dev-sysadmin":
    ensure  => present,
    content => "deb http://pkg.camptocamp.net/dev ${lsbdistcodename} sysadmin",
    require => Apt::Key["5C662D02"],
  }

}
