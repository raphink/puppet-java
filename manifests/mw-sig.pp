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
  if !defined(Apache::Module["headers"]) {
    apache::module {"headers": ensure => present, }
  }

  # other packages for MapFish

  package {"naturaldocs":
    ensure => present,
  }

  # pyyaml package compilation
  package {"libyaml-dev":
    ensure => present,
  }

  # needed for building mapproxy in virtualenvs, see RT#154382
  package { ["libgdal1-dev", "libfreetype6-dev"]:
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
  package {'libapache2-mod-fcgid': ensure => present, }
  apache::module {'fcgid': ensure => present, }

  apache::confd {'mime-type-ogc':
    configuration => '# Add support for OGC standard formats
AddType application/vnd.ogc.context+xml .wmc
AddType application/vnd.ogc.gml .gml
AddType application/vnd.ogc.sld+xml .sld
AddType application/vnd.google-earth.kml+xml .kml
',
  }

  if $repository == 'staging' {
    # set up python eggs directory only for staging now
    file {'/var/cache/python-eggs':
      ensure => directory,
      mode   => '0755',
      owner  => 'www-data',
      group  => 'www-data',
    }
    apache::confd {'WSGIPythonEggs':
      ensure        => present,
      configuration => 'WSGIPythonEggs /var/cache/python-eggs',
      require       => File['/var/cache/python-eggs'],
    }
  }

  include ::generic-tmpl::backport::proj

  # Stuff needed for tiles generation
  if $::osfamily == 'Debian' {
    if $::lsbmajdistrelease >= 6 {  # squeeze or more recent
      package {['python-mapnik2']:
        ensure => present,
      }
    }
    package {'osm2pgsql':
      ensure => present,
    }
  }

}
