class generic-tmpl::os::pkgrepo::sig {

  apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
    ensure  => present,
    content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free",
    require => Apt::Key["5C662D02"],
  }
}
