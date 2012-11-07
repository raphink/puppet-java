class generic-tmpl::mw::postgis::v9_1 {

  include generic-tmpl::os::pkgrepo::sig
  include postgis::debian::v9_1

  apt::preferences { ['postgis', 'postgresql-9.1-postgis']:
    pin      => 'release o=Camptocamp',
    priority => '1100',
  }

  # dependencies
  apt::preferences { ['libgeos-3.3.3', 'libgeos-c1']:
    pin      => 'release o=Camptocamp',
    priority => '1100',
  }

}
