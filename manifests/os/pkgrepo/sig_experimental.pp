class generic-tmpl::os::pkgrepo::sig_experimental {

  apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig-experimental":
    ensure  => present,
    content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig-experimental",
    require => Apt::Key["5C662D02"],
  }
}
