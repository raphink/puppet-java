class generic-tmpl::backport::proj {
  if ($::osfamily == 'Debian') {
    apt::preferences { ['libproj0', 'proj-data']:
      pin      => 'release o=Camptocamp',
      priority => '1100',
    }
  }
}
