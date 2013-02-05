class generic-tmpl::mw::mcollective::client (
  $ssl_ca = undef,
  $ssl_key = undef,
  $ssl_cert = undef,
  $user = undef,
  $password = undef,
) {

  class { '::mcollective::client':
    ssl_ca   => $ssl_ca,
    ssl_key  => $ssl_key,
    ssl_cert => $ssl_cert,
    user     => $user,
    password => $password,
  }

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
  mcollective::application {['healthcheck', 'upgrade', 'nagios']: }
}
