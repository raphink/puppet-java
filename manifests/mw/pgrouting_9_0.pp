class generic-tmpl::mw::pgrouting_9_0 {

  if ! defined (Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"]) {
    apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
      ensure  => present,
      content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free",
    }
  }

  apt::preferences {'postgresql-9.0-pgrouting':
    pin      => 'release o=Camptocamp',
    priority => 1100,
  }

  package {'postgresql-9.0-pgrouting':
      ensure  => present,
      require => Apt::Preferences['postgresql-9.0-pgrouting'],
  }

}
