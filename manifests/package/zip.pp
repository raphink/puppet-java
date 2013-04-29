class generic-tmpl::package::zip {
  @package {['zip', 'unzip']:
    ensure => present,
    tag    => 'common-packages',
  }
}
