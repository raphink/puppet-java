class generic-tmpl::mw::mcollective::rabbitmq {
  include mcollective::rabbitmq

  case $::operatingsystem {
    /Debian|Ubuntu/: {
      apt::preferences { 'rabbitmq-server':
        pin => 'release o=Camptocamp',
        priority => 1100,
      }
    }

    default: { }
  }
}
