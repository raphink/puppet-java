class generic-tmpl::mw-postgis-8-4 {

  class c2c-postgis inherits postgis::debian::v8-4 {
    if  ! defined (Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"]) {
      apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
        ensure  => present,
        content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free",
      }
    }

    Apt::Preferences["postgresql-8.4-postgis"] {
      pin => "release o=Camptocamp",
    }

    Exec["create postgis_template"] {
      require +> Class["mw-postgresql-8-4"],
    }

    Package["postgis"] {
      require +> [
        Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"],
        Apt::Key["5C662D02"],
      ]
    }
  }

  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        lenny :  { include c2c-postgis }
        squeeze: { include postgis::debian::v8-4 }
        default: { fail "mw-postgis-8-4 not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    Ubuntu: {
      case $lsbdistcodename {
        lucid : { include postgis }
        default: { fail "mw-postgis-8-4 not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }

}
