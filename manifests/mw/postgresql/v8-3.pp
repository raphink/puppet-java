class generic-tmpl::mw::postgresql::v8-3 (
  $version='8.3',
  $base_dir=$postgresql_base_dir,
) {

  class {'::generic-tmpl::mw::postgresql':
    version    => $version,
    base_dir   => $base_dir,
  }

}
