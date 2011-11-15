class generic-tmpl::mw-postgis-8-3 {

  include postgis::debian::v8-3

  if ! defined (Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"]) {
    apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
      ensure  => present,
      content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free",
    }
  }

  apt::preferences { ["postgis", "postgresql-8.3-postgis"]:
    pin      => "release o=Camptocamp",
    priority => "1100",
    before   => [Package["postgresql-postgis"], Package["postgis"]],
  }

}
