define generic-tmpl::mw::augeas::lens (
  $ensure='present'
){
  ::augeas::lens {$name:
    lens_source =>"puppet:///modules/generic-tmpl/augeas/${name}.aug",
    test_source =>"puppet:///modules/generic-tmpl/augeas/test_${name}.aug",
  }
}
