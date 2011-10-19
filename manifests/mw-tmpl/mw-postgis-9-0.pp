class generic-tmpl::mw-postgis-9-0 {

  class c2c-postgis inherits postgis::debian::v9-0 {
    if  ! defined (Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"]) {
      apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
        ensure  => present,
        content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free",
      }
    }

    apt::preferences {[
      "postgis",
      "postgresql-9.0-postgis",
      ]:
      pin      => "version 1.5.2-2~c2c+*",
      priority => "1100",
    }

    Exec["create postgis_template"] {
      require +> Class["mw-postgresql-9-0"],
    }

    Package["postgis"] {
      require +> [
        Apt::Preferences["postgis", "postgresql-9.0-postgis"],
        Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"],
        Apt::Key["5C662D02"],
      ]
    }
  }

  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        squeeze: { include c2c-postgis }
        default: { fail "${name} not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }

}
