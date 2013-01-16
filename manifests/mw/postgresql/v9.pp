class generic-tmpl::mw::postgresql::v9 (
  $version = $postgresql_version,
  $base_dir=$postgresql_base_dir,
) {

  # avoid partial configuration on untested-distribution
  if $::lsbdistcodename !~ /^(squeeze|wheezy)$/ {
    fail "${name} not tested on $::operatingsystem/$::lsbdistcodename"
  }

  class {'::generic-tmpl::mw::postgresql':
    version    => $version,
    base_dir   => $base_dir,
  }

}
