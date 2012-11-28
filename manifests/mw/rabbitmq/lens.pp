class generic-tmpl::mw::rabbitmq::lens {
  augeas::lens {'rabbitmq':
    lens_source => 'puppet:///modules/generic-tmpl/augeas/rabbitmq.aug',
    test_source => 'puppet:///modules/generic-tmpl/augeas/test_rabbitmq.aug'
  }
}
