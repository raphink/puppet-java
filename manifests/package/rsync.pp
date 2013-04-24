class generic-tmpl::package::rsync {
  @package {'rsync':
    ensure => present,
    tag    => 'common-packages',
  }
}
