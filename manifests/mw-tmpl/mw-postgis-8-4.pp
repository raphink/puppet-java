class generic-tmpl::mw-postgis-8-4 {

  case $operatingsystem {
    Debian: {
      include postgis::debian::v8-4
    }
    Ubuntu: {
      include postgis::ubuntu::v8-4
    }
  }

  if ! defined (Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"]) {
    apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
      ensure  => present,
      content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free",
    }
  }

  if $lsbdistcodename == "lenny" {
    apt::preferences { ["postgis", "postgresql-8.4-postgis"]:
      pin      => "release o=Camptocamp",
      priority => "1100",
      before   => [Package["postgresql-postgis"], Package["postgis"]],
    }
  }

}
