class generic-tmpl::mw::collectd::lens {
  augeas::lens {'collectd':
    lens_source => 'puppet:///modules/generic-tmpl/augeas/collectd.aug',
    test_source => 'puppet:///modules/generic-tmpl/augeas/test_collectd.aug',
  }
}
