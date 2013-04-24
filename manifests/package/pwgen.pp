class generic-tmpl::package::pwgen {
  @package {'pwgen':
    ensure => present,
    tag    => 'common-packages',
  }
}
