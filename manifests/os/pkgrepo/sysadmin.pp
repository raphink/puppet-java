class generic-tmpl::os::pkgrepo::sysadmin {

  apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sysadmin":
    ensure  => present,
    content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sysadmin",
    require => Apt::Key["5C662D02"],
  }
}
