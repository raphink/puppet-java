class generic-tmpl::mw::postgis (
  $version,
) {

  include ::generic-tmpl::os::pkgrepo::sig
  include ::generic-tmpl::backport::proj
  
  class {'::postgis':
    version => $version,
  }

  apt::preferences { ['postgis', "postgresql-${version}-postgis"]:
    pin      => 'release o=Camptocamp',
    priority => '1100',
  }

}
