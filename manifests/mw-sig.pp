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

  apt::preferences { ['libproj0', 'proj-data']:
    pin      => 'release o=Camptocamp',
    priority => '1100',
  }
}
