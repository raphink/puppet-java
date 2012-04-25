class generic-tmpl::mw::mcollective::client {
  include mcollective-in-5-minutes::client

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

  mcollective-in-5-minutes::plugin { $agents:
    ensure => present,
  }
}
