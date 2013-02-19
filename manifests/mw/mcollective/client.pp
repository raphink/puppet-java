class generic-tmpl::mw::mcollective::client (
  $broker_host = $::stomp_broker,
  $broker_port = $::stomp_ssl_port,
  $broker_user = $::stomp_user,
  $broker_password = $::stomp_password,
  $broker_ssl = true,
  $broker_ssl_cert = undef,
  $broker_ssl_key = undef,
  $broker_ssl_ca = undef,
  $security_provider = 'psk',
  $security_secret = $::mcollective_psk,
  $security_ssl_server_public = undef,
  $security_ssl_client_public = undef,
  $security_ssl_client_private = undef,
) {

  class { '::mcollective::client':
    broker_host                 => $broker_host,
    broker_port                 => $broker_port,
    broker_user                 => $broker_user,
    broker_password             => $broker_password,
    broker_ssl                  => $broker_ssl,
    broker_ssl_cert             => $broker_ssl_cert,
    broker_ssl_key              => $broker_ssl_key,
    broker_ssl_ca               => $broker_ssl_ca,
    security_provider           => $security_provider,
    security_secret             => $security_secret,
    security_ssl_server_public  => $security_ssl_server_public,
    security_ssl_client_private => $security_ssl_client_private,
    security_ssl_client_public  => $security_ssl_client_public,
  }

  file { '/etc/profile.d/mco-client':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'export STOMP_USER="$USER"
export MCOLLECTIVE_SSL_PRIVATE="$HOME/.mc/$USER-private.pem"
export MCOLLECTIVE_SSL_PUBLIC="$HOME/.mc/$USER-public.pem"
',
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
