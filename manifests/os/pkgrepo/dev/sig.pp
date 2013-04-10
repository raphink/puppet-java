class generic-tmpl::os::pkgrepo::dev::sig {

  apt::sources_list {"c2c-${lsbdistcodename}-dev-sig":
    ensure  => present,
    content => "deb http://pkg.camptocamp.net/dev ${lsbdistcodename} sig sig-non-free",
    require => Apt::Key["5C662D02"],
  }

}
