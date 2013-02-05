class generic-tmpl::mw::mcollective::rabbitmq (
  $cluster_disk_nodes = [],
  $erlang_cookie,
  $vhost = '/mcollective',
  $user = 'guest',
  $password = 'guest',
  $ldap_auth=false,
  $ldap_server=undef,
  $ldap_user_dn_pattern=undef,
  $ldap_use_ssl=undef,
  $ldap_port=undef,
  $ldap_log=undef,
) {

  # Copy SSL keys to give them the proper rights
  file {
    '/etc/rabbitmq/ssl/ca.pem':
      ensure => file,
      owner  => 'rabbitmq',
      group  => 'rabbitmq',
      source => '/var/lib/puppet/ssl/certs/ca.pem';

    "/etc/rabbitmq/ssl/${::fqdn}.crt":
      ensure => file,
      owner  => 'rabbitmq',
      group  => 'rabbitmq',
      source => "/var/lib/puppet/ssl/certs/${::fqdn}.pem";

    "/etc/rabbitmq/ssl/${::fqdn}.key":
      ensure => file,
      owner  => 'rabbitmq',
      group  => 'rabbitmq',
      source => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem";
  }

  class { '::rabbitmq::server':
    env_config           => 'export SERVER_ERL_ARGS="$SERVER_ERL_ARGS -kernel inet_dist_listen_min 35197 -kernel inet_dist_listen_max 35197 -kernel net_ticktime 600"',
    config_cluster       => true,
    cluster_disk_nodes   => $cluster_disk_nodes,
    erlang_cookie        => $erlang_cookie,
    ssl                  => true,
    ssl_cacert           => '/etc/rabbitmq/ssl/ca.pem',
    ssl_cert             => "/etc/rabbitmq/ssl/${::fqdn}.crt",
    ssl_key              => "/etc/rabbitmq/ssl/${::fqdn}.key",
    config_stomp         => true,
    stomp_port           => '61613',
    ssl_stomp_port       => '61614',
    ldap_auth            => $ldap_auth,
    ldap_server          => $ldap_server,
    ldap_user_dn_pattern => $ldap_user_dn_pattern,
    ldap_use_ssl         => $ldap_use_ssl,
    ldap_port            => $ldap_port,
    ldap_log             => $ldap_log,
    #require             => [
    #  File['/etc/rabbitmq/ssl/ca.pem'],
    #  File["/etc/rabbitmq/ssl/${::fqdn}.crt"],
    #  File["/etc/rabbitmq/ssl/${::fqdn}.key"],
    #],
  }

  rabbitmq_plugin { ['amqp_client', 'rabbitmq_stomp']:
    ensure => present,
    notify => Service['rabbitmq-server'],
  }

  rabbitmq_vhost { $vhost: }

  rabbitmq_user { $user:
    password => $password,
    admin    => true,
  }

  rabbitmq_user_permissions { "${user}@${vhost}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_exchange {
    "mcollective_broadcast@${vhost}":
      type     => 'topic',
      user     => $user,
      password => $password;

    "mcollective_directed@${vhost}":
      type     => 'direct',
      user     => $user,
      password => $password;
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
