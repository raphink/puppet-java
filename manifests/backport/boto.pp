class generic-tmpl::backport::boto {
  apt::preferences {'python-boto':
    pin => 'release o=Camptocamp',
    priority => 1100,
  }
  
  package {'python-boto':
    require => Apt::Preferences['python-boto'],
  }
}
