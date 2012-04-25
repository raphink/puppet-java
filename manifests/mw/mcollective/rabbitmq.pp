class generic-tmpl::mw::mcollective::rabbitmq {
  include mcollective-in-5-minutes::rabbitmq

  apt::preferences { 'rabbitmq-server':
    pin => 'release o=Camptocamp',
    priority => 1100,
  }
}
