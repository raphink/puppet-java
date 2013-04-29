class generic-tmpl::package::emacs {
  case $::osfamily {
    'Debian': { $pkg_name = 'emacs21-nox' }
    'RedHat': { $pkg_name = 'emacs-nox' }
    default: {}
  }

  @package {'emacs':
    ensure => present,
    name   => $pkg_name,
    tag    => 'common-packages',
  }
}
