# Template middelware SIG
#
# Ajoute les sources-list sig de camptocamp et installe :
# - mapserver,
# - mapfish, 
# - cartoweb,
# - tilecache,
#  avec leurs dépendances depuis le repository camptocamp.
#

class generic-tmpl::mw-sig {

  class c2c-mapserver inherits mapserver::debian {

    # Camptocamp SIG sources list
    apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sig":
      ensure  => present,
      content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sig sig-non-free\n",
      require => Apt::Key["5C662D02"],
    }

    apt::preferences{"sig":
      package  => "*",
      pin      => "release c=sig, o=Camptocamp",
      priority => 1001,
    }
    apt::preferences{"sig-non-free":
      package  => "*",
      pin      => "release c=sig-non-free, o=Camptocamp",
      priority => 1001,
    }

    apt::preferences{["libgeos-c1", "libgeos-dev", "proj"]:
      pin      => "release a=lenny-backports, o=Camptocamp",
      priority => 1001,
    }

    case $mapserver_version {
      default: { fail "Unsupported value for \$mapserver_version. Choices are 5.4 or 5.6." }
      "","5.4": {
        Package {
          require => [ Exec["apt-get_update"],
                       Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"],
                       Apt::Preferences["sig", "sig-non-free", "libgeos-c1", "libgeos-dev", "proj"],
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
                       Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"], Apt::Preferences["sig", "sig-non-free", "libgeos-c1", "libgeos-dev", "proj"],
                       Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-mapserver-5.6"], Apt::Preferences["mapserver-5.6"]
                     ],
        }
      }
    }

  }

  case $operatingsystem {
    Debian:  { include c2c-mapserver }
    default: { fail "Unsupported operatingsystem ${operatingsystem}" }
  }

  package {"libgdal1-1.5.0": ensure => purged, }

  include buildenv::c
  include python::dev
  include python::virtualenv
  include tilecache::base

  # Apache modules for MapFish

  include apache::reverseproxy

  package {"libapache2-mod-wsgi": ensure => present, }
  apache::module {"headers": ensure => present, }

  # other packages for MapFish

  package {"naturaldocs":
    ensure => present,
  }


  # Apache module for Mapserver
  package {"libapache2-mod-fcgid": ensure => present, }
  apache::module {"fcgid": ensure => present, }
  

  # Custom projections in EPSG file

  line {"custom-epsg-proj-3785":
    file    => "/usr/share/proj/epsg",
    line    => "<3785> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs <>",
    require => Package["proj-data"],
  }
  line {"custom-epsg-proj-3857":
    file    => "/usr/share/proj/epsg",
    line    => "<3857> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs <>",
    require => Package["proj-data"],
  }
  line {"custom-epsg-proj-900913":
    file    => "/usr/share/proj/epsg",
    line    => "<900913> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs <>",
    require => Package["proj-data"],
  }
  line {"custom-epsg-proj-32640":
    file    => "/usr/share/proj/epsg",
    line    => "<32640> +proj=utm +zone=40 +ellps=WGS84 +datum=WGS84 +units=m +no_defs no_defs <>",
    require => Package["proj-data"],
  }

}
