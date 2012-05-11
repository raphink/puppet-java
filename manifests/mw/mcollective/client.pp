class generic-tmpl::mw::mcollective::client {
  include ::mcollective::client

  case $::operatingsystem {
    # Mcollective agent packages are split in Debian/Ubuntu
    /Debian|Ubuntu/: {
      $agents = [
      'augeasquery-client',
      'filemgr-client',
      'nettest-client',
      'nrpe-client',
      'package-client',
      'process-client',
      'puppetd-client',
      'service-client',
      'stomputil-client',
      ]

      mcollective::plugin { $agents:
        ensure => present,
      }

    }

    default: { }
  }

  # Add applications
  mcollective::application {['healthcheck', 'upgrade']: }
}
