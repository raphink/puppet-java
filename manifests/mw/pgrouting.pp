class generic-tmpl::mw::pgrouting (
  $version => '9.0',
) {

  validate_re($version, '^9\.0$', "version ${version} is not supported!")

  include generic-tmpl::os::pkgrepo::sig

  apt::preferences {'postgresql-${version}-pgrouting':
    pin      => 'release o=Camptocamp',
    priority => 1100,
  }

  package {'postgresql-${version}-pgrouting':
    ensure  => present,
    require => Apt::Preferences['postgresql-9.0-pgrouting'],
  }

}
