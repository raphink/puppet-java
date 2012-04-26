class generic-tmpl::mw::pgrouting_9_0 {

  include generic-tmpl::os::pkgrepo::sig

  apt::preferences {'postgresql-9.0-pgrouting':
    pin      => 'release o=Camptocamp',
    priority => 1100,
  }

  package {'postgresql-9.0-pgrouting':
    ensure  => present,
    require => Apt::Preferences['postgresql-9.0-pgrouting'],
  }

}
