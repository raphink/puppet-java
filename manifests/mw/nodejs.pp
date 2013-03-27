class generic-tmpl::mw::nodejs {
  package {['nodejs', 'npm']:
    ensure  => present,
    require => Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sysadmin"],
  }
  apt::preferences {['nodejs', 'npm']:
    ensure   => present,
    pin      => 'release o=Camptocamp',
    priority => 1100,
  }
}
