class generic-tmpl::mw-sig-lenny inherits mapserver::debian {

  case $mapserver_version {
    default: { fail "Unsupported value for \$mapserver_version. Choices are 5.4 or 5.6." }
    "","5.4": {
      Package {
        require => [ Exec["apt-get_update"],
                     Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"],
                     Apt::Preferences["sig", "sig-non-free", "libgeos-c1", "proj"],
                   ],
      }
    }
    "5.6": {
      apt::sources_list {"c2c-${lsbdistcodename}-${repository}-mapserver-5.6":
        ensure  => present,
        content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} mapserver-5.6\n",
        require => Apt::Key["5C662D02"],
      }
      apt::preferences{"mapserver-5.6":
        package  => "*",
        pin      => "release c=mapserver-5.6",
        priority => 1001,
      }
      Package {
        require => [ Exec["apt-get_update"],
                     Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"], Apt::Preferences["sig", "sig-non-free", "libgeos-c1", "proj"],
                     Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-mapserver-5.6"], Apt::Preferences["mapserver-5.6"]
                   ],
      }
    }
  }

}

