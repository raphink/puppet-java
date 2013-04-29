class generic-tmpl::package::wget {
  @package {'wget':
    ensure => present,
    tag    => 'common-packages',
  }
}
