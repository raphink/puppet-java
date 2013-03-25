class generic-tmpl::mw::phantomjs {
  package {'phantomjs':
    ensure  => present,
    require => Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sysadmin"],
  }
  apt::preferences {'phantomjs':
    ensure   => present,
    pin      => 'release o=Camptocamp',
    priority => 1100,
  }
}
