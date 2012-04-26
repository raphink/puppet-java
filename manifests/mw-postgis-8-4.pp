class generic-tmpl::mw-postgis-8-4 {

  include generic-tmpl::os::pkgrepo::sig

  case $operatingsystem {
    Debian: {
      include postgis::debian::v8-4
    }
    Ubuntu: {
      include postgis::ubuntu::v8-4
    }
  }

  if $lsbdistcodename == "lenny" {
    apt::preferences { ["postgis", "postgresql-8.4-postgis"]:
      pin      => "release o=Camptocamp",
      priority => "1100",
    }
  }

}
