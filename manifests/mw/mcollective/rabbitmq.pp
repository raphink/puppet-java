class generic-tmpl::mw::mcollective::rabbitmq {
  class { '::rabbitmq::server':
    env_config         => 'export SERVER_ERL_ARGS="$SERVER_ERL_ARGS -kernel inet_dist_listen_min 35197 -kernel inet_dist_listen_max 35197 -kernel net_ticktime 600"',
    config_cluster     => true,
    cluster_disk_nodes => ['rabbit@ip-10-49-21-59', 'rabbit@bgdiback02p'],
    erlang_cookie      => 'aeph4eel2Lu5sazeengohcaeDoorieng',
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
