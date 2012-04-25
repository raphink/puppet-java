class generic-tmpl::mw::mcollective::client {
  include ::mcollective::client

  $agents = $::operatingsystem ? {
    /Debian|Ubuntu/ => [
      'augeasquery-client',
      'filemgr-client',
      'nettest-client',
      'nrpe-client',
      'package-client',
      'process-client',
      'puppetd-client',
      'service-client',
      'stomputil-client',
      ],
    /RedHat|CentOS/ => [
      'augeasquery',
      'filemgr',
      'nettest',
      'nrpe',
      'package',
      'process',
      'puppetd',
      'service',
      'stomputil',
      ],
  }

  mcollective::plugin { $agents:
    ensure => present,
  }
}
