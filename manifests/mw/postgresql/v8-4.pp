class generic-tmpl::mw::postgresql::v8-4 {

  class {'::generic-tmpl::mw::postgresql':
    version => '8.4',
  }

  if $::lsbdistcodename == 'lenny' {
    apt::preferences {'libpq-dev':
      pin      => 'release o=Camptocamp',
      priority => 1100,
    }
  }

}
