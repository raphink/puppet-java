class generic-tmpl::mw::erlang::lens {
  augeas::lens {'erlang':
    lens_source => 'puppet:///modules/generic-tmpl/augeas/erlang.aug',
    test_source => 'puppet:///modules/generic-tmpl/augeas/test_erlang.aug'
  }
}
