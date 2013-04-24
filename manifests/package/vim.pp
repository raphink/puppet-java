class generic-tmpl::package::vim {
  case $::osfamilly {
    'Debian': { $pkg_name = 'vim' }
    'RedHat': { $pkg_name = '' }
    default: { }
  }
  @package {'vim':
    ensure => present,
    name   => $pkg_name,
    tag    => 'common-packages',
  }
}
