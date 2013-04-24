class generic-tmpl::package::gnupg {
  if versioncmp($::lsbmajdistrelease, 5) > 0 {
    $pkg_name = 'gnupg2'
  } else {
    $pkg_name = 'gnupg'
  }

  @package {'gnupg':
    ensure => present,
    name   => $pkg_name,
    tag    => 'common-packages',
  }
}
