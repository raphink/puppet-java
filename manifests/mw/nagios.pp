class generic-tmpl::mw::nagios {

  if $::lsbdistcodename == 'lenny' {
    apt::preferences {[
      'nagios3-core',
      'nagios3-common',
      'nagios-plugins',
      'nagios-plugins-standard',
      'nagios-plugins-basic',
    ]:
        pin      => 'release o=Camptocamp',
        priority => '1100',
    }
  }

  include nagios
}
