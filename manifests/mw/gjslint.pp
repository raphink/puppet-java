class generic-tmpl::mw::gjslint {
  package {'closure-linter':
    ensure  => present,
    require => Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sysadmin"],
  }
  apt::preferences {'closure-linter':
    ensure   => present,
    pin      => 'release o=Camptocamp',
    priority => 1100,
  }
}
