class generic-tmpl::mw-postgis-8-4 {

  class c2c-postgis inherits postgis::debian::v8-4 {
    if  ! defined (Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"]) {
      apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
        ensure  => present,
        content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free",
      }
    }

    Apt::Preferences["postgresql-8.4-postgis"] {
      pin => "release o=c2c",
    }

    Exec["create postgis_template"] {
      require +> Class["mw-postgresql-8-4"],
    }

    Package["postgis"] {
      require +> [
        Apt::Sources_list["sig-${lsbdistcodename}-postgresql-8.4"],
        Apt::Key["5C662D02"],
      ]
    }
  }

  case $lsbdistcodename {
    # Debian
    lenny :  { include c2c-postgis }

    # Ubuntu
    lucid : { include postgis }

    default: { fail "mw-postgis-8-4 not supported for ${operatingsystem}/${lsbdistcodename}"}
  }

}
