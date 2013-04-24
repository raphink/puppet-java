class generic-tmpl::package::curl {
  @package {'curl':
    ensure => present,
    tag    => 'common-packages',
  }
}
