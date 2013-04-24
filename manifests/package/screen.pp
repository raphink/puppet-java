class generic-tmpl::package::screen {
  @package {'screen':
    ensure => present,
    tag    => 'common-packages',
  }
}
