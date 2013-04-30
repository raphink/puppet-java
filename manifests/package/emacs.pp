class generic-tmpl::package::emacs {
  case $::osfamily {
    Debian: {
      case $::lsbdistmajrelease {
        5: { $pkg_name = 'emacs21-nox' }
        default: { $pkg_name = 'emacs23-nox' }
      }
    }
    RedHat: { $pkg_name = 'emacs-nox' }
    default: {}
  }

  @package {'emacs':
    ensure => present,
    name   => $pkg_name,
    tag    => 'common-packages',
  }
}
