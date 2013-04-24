class generic-tmpl::package::elinks {
  @package {'elinks':
    ensure => present,
    tag    => 'common-packages',
  }
}
