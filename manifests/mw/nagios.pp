class generic-tmpl::mw::nagios {

  if ::osfamily == 'Debian' {

    $common_packages = [
      'nagios3-core',
      'nagios3-common',
      'nagios-plugins',
      'nagios-plugins-standard',
      'nagios-plugins-basic'
    ]

    $packages = $::lsbdistcodename ? {
      'lenny'   => [$common_packages,['nsca']],
      'squeeze' => $common_packages,
      'wheezy'  => ['nsca'],
      default   => [],
    }

    apt::preferences {$packages:
      pin      => 'release o=Camptocamp',
      priority => '1100',
    }

  }

  include ::nagios

}
