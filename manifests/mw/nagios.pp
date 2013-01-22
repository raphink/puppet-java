class generic-tmpl::mw::nagios {

  $common_packages = [
    'nagios3-core',
    'nagios3-common',
    'nagios-plugins',
    'nagios-plugins-standard',
    'nagios-plugins-basic'
  ]

  if $::lsbdistcodename == 'lenny' {
    $packages = [$common_packages,['nsca']]
  } elsif $::lsbdistcodename == 'squeeze' {
    $packages = $common_packages
  } elsif $::lsbdistcodename == 'wheezy' {
    $packages = ['nsca']
  }

  apt::preferences {$packages:
    pin      => 'release o=Camptocamp',
    priority => '1100',
  }

  include ::nagios

}
