class generic-tmpl::package::tmux {

  if $::lsbdistcodename == 'squeeze' {
    # tmux from squeeze backports
    apt::preferences {'tmux':
      pin      => 'release a=squeeze-backports',
      priority => 1100,
    }
  }

  @package {'tmux':
    ensure => present,
    tag    => 'common-packages',
  }
}
