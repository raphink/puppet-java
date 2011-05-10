class generic-tmpl::mw-postgis-8-4 {

  class c2c-postgis inherits postgis::debian::v8-4 {
    if  ! defined (Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"]) {
      apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
        ensure  => present,
        content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free",
      }
    }

    Exec["create postgis_template"] {
      require +> Class["mw-postgresql-8-4"],
    }

    if $lsbdistcodename == "lenny" {
      Apt::Preferences["postgresql-8.4-postgis"] {
        pin => "release o=Camptocamp",
      }

      Package["postgis"] {
        require +> [
          Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"],
          Apt::Key["5C662D02"],
        ]
      }
    }
  }

  case $lsbdistcodename {
    # Debian
    lenny :  { include c2c-postgis }
    squeeze :  { include c2c-postgis }

    # Ubuntu
    lucid : { include c2c-postgis }

    default: { fail "mw-postgis-8-4 not supported for ${operatingsystem}/${lsbdistcodename}"}
  }

}
