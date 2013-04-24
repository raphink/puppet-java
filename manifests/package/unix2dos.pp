class generic-tmpl::package::unix2dos {

  case $::osfamily {
    'Debian': { $pkg_name = 'dos2unix' }
    'RedHat': { $pkg_name = 'unix2dos' }
    default:  {}
  }


  @package {'unix2dos':
    ensure => present,
    name   => $pkg_name,
    tag    => 'common-packages',
  }
}
