class generic-tmpl::package::vim {
  case $::osfamily {
    'Debian': { $pkg_name = 'vim' }
    'RedHat': { $pkg_name = 'vim-enhanced' }
    default: { }
  }
  @package {'vim':
    ensure => present,
    name   => $pkg_name,
    tag    => 'common-packages',
  }
}
