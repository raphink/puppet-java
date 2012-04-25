class generic-tmpl::mw::mcollective::client {
  include ::mcollective::client

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
