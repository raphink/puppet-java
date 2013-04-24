class generic-tmpl::package::sharutils {
  if $::osfamilly == 'Debian' {
    @package {'sharutils':
      ensure => present,
      tag    => 'common-packages',
    }
  }
}
