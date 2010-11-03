class generic-tmpl::mw-postgis-8-3 {

  class c2c-postgis inherits postgis::debian::v8-3 {
    if  ! defined (Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"]) {
      apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
        ensure  => present,
        content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free",
      }
    }

    Exec["create postgis_template"] {
      require +> Class["mw-postgresql-8-3"],
    }

    Package["postgis"] {
      require +> [
        Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"],
        Apt::Key["5C662D02"],
      ]
    }
  }

  include c2c-postgis

}
