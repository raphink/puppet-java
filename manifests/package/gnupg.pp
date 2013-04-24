class generic-tmpl::package::gnupg {
  if $::libdistmajrelease > 5 {
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
