class generic-tmpl::package::sharutils {
  if $::osfamily == 'Debian' {
    @package {'sharutils':
      ensure => present,
      tag    => 'common-packages',
    }
  }
}
