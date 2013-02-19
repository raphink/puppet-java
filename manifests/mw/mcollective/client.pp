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
  $ssl_source_dir = undef,
) {

  if ($security_provider == 'ssl' and $ssl_source_dir) {
    $_broker_ssl_key = '/etc/mcollective/ssl/mco-client.key'
    $_broker_ssl_cert = '/etc/mcollective/ssl/mco-client.crt'
    $_broker_ssl_ca = '/etc/mcollective/ssl/ca.pem'
    file {
      $_broker_ssl_key:
        source => "${ssl_source_dir}/mco-client.key",
        owner  => 'root',
        group  => 'root',
        mode   => '0644';

      $_broker_ssl_cert:
        source => "${ssl_source_dir}/mco-client.crt",
        owner  => 'root',
        group  => 'root',
        mode   => '0644';

      $_broker_ssl_ca:
        source => '/var/lib/puppet/ssl/certs/ca.pem',
        owner  => 'root',
        group  => 'root',
        mode   => '0644';
    }
  } else {
    $_broker_ssl_key = $broker_ssl_key
    $_broker_ssl_cert = $broker_ssl_cert
    $_broker_ssl_ca = $broker_ssl_ca
  }

  class { '::mcollective::client':
    broker_host                 => $broker_host,
    broker_port                 => $broker_port,
    broker_user                 => $broker_user,
    broker_password             => $broker_password,
    broker_ssl                  => $broker_ssl,
    broker_ssl_cert             => $_broker_ssl_cert,
    broker_ssl_key              => $_broker_ssl_key,
    broker_ssl_ca               => $_broker_ssl_ca,
    security_provider           => $security_provider,
    security_secret             => $security_secret,
    security_ssl_server_public  => $security_ssl_server_public,
    security_ssl_client_private => $security_ssl_client_private,
    security_ssl_client_public  => $security_ssl_client_public,
  }

  file { '/etc/profile.d/mco-client.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => inline_template('<%- unless @broker_user or @broker_user.nil? -%>
export STOMP_USER="$USER"
<%- end -%>
export MCOLLECTIVE_SSL_PRIVATE="$HOME/.mc/$USER-private.pem"
export MCOLLECTIVE_SSL_PUBLIC="$HOME/.mc/$USER.pem"
'),
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
