class generic-tmpl::mw::mcollective::rabbitmq {

  # Copy SSL keys to give them the proper rights
  #file {
  #  '/etc/rabbitmq/ssl/ca.pem':
  #    ensure => file,
  #    owner  => 'rabbitmq',
  #    group  => 'rabbitmq',
  #    source => '/var/lib/puppet/ssl/certs/ca.pem';

  #  "/etc/rabbitmq/ssl/${::fqdn}.crt":
  #    ensure => file,
  #    owner  => 'rabbitmq',
  #    group  => 'rabbitmq',
  #    source => "/var/lib/puppet/ssl/certs/${::fqdn}.pem";

  #  "/etc/rabbitmq/ssl/${::fqdn}.key":
  #    ensure => file,
  #    owner  => 'rabbitmq',
  #    group  => 'rabbitmq',
  #    source => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem";
  #}

  class { '::rabbitmq::server':
    env_config         => 'export SERVER_ERL_ARGS="$SERVER_ERL_ARGS -kernel inet_dist_listen_min 35197 -kernel inet_dist_listen_max 35197 -kernel net_ticktime 600"',
    config_cluster     => true,
    cluster_disk_nodes => ['ip-10-49-21-59', 'bgdiback02p'],
    erlang_cookie      => 'aeph4eel2Lu5sazeengohcaeDoorieng',
    ssl                => true,
    ssl_cacert         => '/etc/rabbitmq/ssl/ca.pem',
    ssl_cert           => "/etc/rabbitmq/ssl/${::fqdn}.crt",
    ssl_key            => "/etc/rabbitmq/ssl/${::fqdn}.key",
    config_stomp       => true,
    stomp_port         => '61613',
    ssl_stomp_port     => '61614',
    #require           => [
    #  File['/etc/rabbitmq/ssl/ca.pem'],
    #  File["/etc/rabbitmq/ssl/${::fqdn}.crt"],
    #  File["/etc/rabbitmq/ssl/${::fqdn}.key"],
    #],
  }

  rabbitmq_plugin {
    ["amqp_client", "rabbitmq_stomp"]: ensure => present,
  }

  case $::operatingsystem {
    /Debian|Ubuntu/: {
      apt::preferences { 'rabbitmq-server':
        pin => 'release o=Camptocamp',
        priority => 1100,
      }
    }

    default: { }
  }
}
