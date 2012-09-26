class generic-tmpl::mw::collectd::lens {
  augeas::lens {'collectd':
    lens_source => 'puppet:///modules/generic-tmpl/lenses/collectd.aug',
    test_source => 'puppet:///modules/generic-tmpl/lenses/test_collectd.aug',
  }
}
