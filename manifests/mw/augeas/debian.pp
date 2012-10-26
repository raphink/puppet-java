class generic-tmpl::mw::augeas::debian {

  include ::augeas::debian

  apt::preferences {'augeas':
    package  => 'augeas-lenses augeas-tools libaugeas0 libaugeas-ruby1.8',
    ensure   => present,
    pin      => "release o=Camptocamp",
    priority => 1100;
  }
}
