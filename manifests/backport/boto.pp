class generic-tmpl::backport::boto {
  include aws::boto

  apt::preferences {'python-boto':
    pin => 'release o=Camptocamp',
    priority => 1100,
  }
}
