class generic-tmpl::package::cvs {
  @package {'cvs':
    ensure => present,
    tag    => 'common-packages',
  }
}
