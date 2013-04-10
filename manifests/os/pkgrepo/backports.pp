class generic-tmpl::os::pkgrepo::backports {

  apt::sources_list {"c2c-${lsbdistcodename}-${repository}-backports":
    ensure  => present,
    content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename}-backports main contrib non-free",
    require => Apt::Key["5C662D02"],
  }
}
