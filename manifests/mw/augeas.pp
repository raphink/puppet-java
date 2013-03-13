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

  include ::augeas

  $augeas_version = $::osfamily ? {
    RedHat  => $::lsbmajdistrelease ? {
      6       => "1.0.0-1.el${::lsbmajdistrelease}",
      5       => "1.0.0-1.el${::lsbmajdistrelease}",
      4       => "1.0.0-1.el${::lsbmajdistrelease}",
      default => 'present',
    },
    default => 'present',
  }

  if $::osfamily == 'Debian' {
    $augeas_ruby = $augeas::params::ruby_pkg
    validate_re($augeas_ruby, '^\S+$')

    apt::preferences {'augeas':
      ensure   => present,
      package  => "augeas-lenses augeas-tools augeas-doc libaugeas0 ${augeas_ruby}",
      pin      => 'release o=Camptocamp',
      priority => 1100;
    }
  }
}
