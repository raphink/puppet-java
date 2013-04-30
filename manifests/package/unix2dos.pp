class generic-tmpl::package::unix2dos {

  case $::osfamily {
    'RedHat': {
      @package {'unix2dos':
        ensure => present,
        tag    => 'common-packages',
      }
    }
    default:  {}
  }
}
