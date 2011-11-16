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

  # avoid partial configuration on untested-distribution
  if $lsbdistcodename !~ /^(lenny|squeeze)$/ {
    fail "${name} not tested on ${operatingsystem}/${lsbdistcodename}"
  }

  case $operatingsystem {
    Debian:  { include generic-tmpl::c2c-mapserver }
    default: { fail "Unsupported operatingsystem ${operatingsystem}" }
  }

  package {"libgdal1-1.5.0": ensure => purged, }

  include buildenv::c
  include buildenv::postgresql
  include python::dev
  include python::virtualenv
  include tilecache::base

  apt::preferences{["tilecache", "python-image-merge"]:
    pin      => "release o=Camptocamp",
    priority => 1001,
  }

  # Apache modules for MapFish

  include apache::reverseproxy

  package {"libapache2-mod-wsgi": ensure => present, }
  apache::module {"headers": ensure => present, }

  # other packages for MapFish

  package {"naturaldocs":
    ensure => present,
  }

  # pyyaml package compilation
  package {"libyaml-dev":
    ensure => present,
  }

  # python-lxml package compilation
  package {["libxml2-dev", "libxslt1-dev"]:
    ensure => present,
  }
  package{"python-lxml":
    ensure => absent,
  }

  # Apache module for Mapserver
  package {"libapache2-mod-fcgid": ensure => present, }
  apache::module {"fcgid": ensure => present, }
  

  # Custom projections in EPSG file

  common::line {"custom-epsg-proj-3785":
    file    => "/usr/share/proj/epsg",
    line    => "<3785> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs <>",
    require => Package["proj-data"],
  }
  common::line {"custom-epsg-proj-3857":
    file    => "/usr/share/proj/epsg",
    line    => "<3857> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs <>",
    require => Package["proj-data"],
  }
  common::line {"custom-epsg-proj-900913":
    file    => "/usr/share/proj/epsg",
    line    => "<900913> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs <>",
    require => Package["proj-data"],
  }
  common::line {"custom-epsg-proj-32640":
    file    => "/usr/share/proj/epsg",
    line    => "<32640> +proj=utm +zone=40 +ellps=WGS84 +datum=WGS84 +units=m +no_defs no_defs <>",
    require => Package["proj-data"],
  }

}
