class generic-tmpl::package::dos2unix {
  @package {'dos2unix':
    ensure => present,
    tag    => 'common-packages',
  }
}
