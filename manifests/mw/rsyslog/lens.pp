class generic-tmpl::mw::rsyslog::lens {
  augeas::lens {'rsyslog':
    lens_source => 'puppet:///modules/generic-tmpl/augeas/rsyslog.aug',
    test_source => 'puppet:///modules/generic-tmpl/augeas/test_rsyslog.aug',
  }
}
