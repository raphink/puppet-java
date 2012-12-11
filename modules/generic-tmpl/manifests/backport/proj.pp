class generic-tmpl::backport::proj {
  apt::preferences { ['libproj0', 'proj-data']:
    pin      => 'release o=Camptocamp',
    priority => '1100',
  }
}
