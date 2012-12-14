class generic-tmpl::mw::augeas::debian {

  include ::augeas::debian

  $augeas_ruby = $::lsbdistcodename ? {
    'wheezy' => 'libaugeas-ruby1.9.1',
    default  => 'libaugeas-ruby1.8',
  }

  apt::preferences {'augeas':
    ensure   => present,
    package  => "augeas-lenses augeas-tools libaugeas0 ${augeas_ruby}",
    pin      => 'release o=Camptocamp',
    priority => 1100;
  }
}
