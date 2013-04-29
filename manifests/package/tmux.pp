class generic-tmpl::package::tmux {
  @package {'tmux':
    ensure => present,
    tag    => 'common-packages',
  }
}
