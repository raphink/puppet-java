class generic-tmpl::package::ackgrep {

  case $::osfamily {
    Debian: { $pkg_name = 'ack-grep' }
    RedHat: { $pkg_name = 'ack' }
  }

  @package {'ackgrep':
    ensure => present,
    name   => $pkg_name,
    tag    => 'common-packages',
  }
}
