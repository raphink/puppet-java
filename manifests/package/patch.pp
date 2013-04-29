class generic-tmpl::package::patch {
  @package {'patch':
    ensure => present,
    tag    => 'common-packages',
  }
}
