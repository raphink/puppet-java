class generic-tmpl::mw::rabbitmq::ssl (
  $port='5671',
  $cacertfile='/var/lib/puppet/ssl/certs/ca.pem',
  $certfile="/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  $keyfile="/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
) {
  include ::generic-tmpl::mw::rabbitmq::lens

  augeas {'Setup rabbitmq for SSL':
    incl    => '/etc/rabbitmq/rabbitmq.config',
    lens    => 'Rabbitmq.lns',
    changes => [
      'rm rabbit/ssl_listeners', # Use only our values
      "set rabbit/ssl_listeners/value ${port}",
      'rm rabbit/ssl_options', # Use only our values
      "set rabbit/ssl_options/cacertfile ${cacertfile}",
      "set rabbit/ssl_options/certfile ${certfile}",
      "set rabbit/ssl_options/keyfile ${keyfile}",
      "set rabbit/ssl_options/verify verify_peer",
      "set rabbit/ssl_options/fail_if_no_peer_cert false",
    ],
    notify  => Service['rabbitmq-server'],
    require => [
      Package['rabbitmq-server'],
      Augeas::Lens['rabbitmq'],
    ],
  }
}
