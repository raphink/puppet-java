#
# == Class: generic-tmpl::mw::augeas
#
# Cette classe permet d'installer augeas a la version voulue
#
# Dépendances:
#  - Module camptocamp/puppet-augeas
#  - Class os-debian-repository du module camptocamp/puppet-generic-tmpl
#
class generic-tmpl::mw::augeas {

  $augeas_version = $::osfamily ? {
    RedHat  => $::lsbmajdistrelease ? {
      6       => "1.0.0-1.el${::lsbmajdistrelease}",
      5       => "1.0.0-1.el${::lsbmajdistrelease}",
      4       => "1.0.0-1.el${::lsbmajdistrelease}",
      default => 'present',
    },
    default => 'present',
  }

  $augeas_ruby_version = $::operatingsystem ? {
    default => 'present',
  }

  case $::osfamily {
    Debian: {
      include generic-tmpl::mw::augeas::debian
    }
    RedHat: {
      include generic-tmpl::mw::augeas::redhat
    }
    default: {
      fail("Unsupported OS family ${::osfamily}")
    }
  }

  # remove legacy custom lens location to avoid confusion.
  # use augeas::lens instead please.
  file { '/usr/share/augeas/lenses/contrib':
    ensure  => absent,
    purge   => true,
    recurse => true,
    force   => true,
  }
}
