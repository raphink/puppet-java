class generic-tmpl::mw-postgis-9-0 {

  include generic-tmpl::os::pkgrepo::sig
  include postgis::debian::v9-0

  apt::preferences { ["postgis", "postgresql-9.0-postgis"]:
    pin      => "release o=Camptocamp",
    priority => "1100",
  }

}
