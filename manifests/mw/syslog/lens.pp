class generic-tmpl::mw::syslog::lens {
  augeas::lens {'syslog':
    lens_source => 'puppet:///modules/generic-tmpl/augeas/syslog.aug',
    test_source => 'puppet:///modules/generic-tmpl/augeas/test_syslog.aug',
  }
}
