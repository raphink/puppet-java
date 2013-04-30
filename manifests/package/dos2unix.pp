class generic-tmpl::package::dos2unix {
  case $::lsbdistcodename {
    lenny: { $pkg_name = 'tofrodos' }
    default: { $pkg_name = 'dos2unix' }
  }
  @package {$pkg_name:
    ensure => present,
    tag    => 'common-packages',
  }
}
