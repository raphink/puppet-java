class generic-tmpl::mw::mapcache(
  $memcached_max_memory      = false,
  $memcached_lock_memory     = false,
  $memcached_listen_ip       = '0.0.0.0',
  $memcached_tcp_port        = 11211,
  $memcached_udp_port        = 11211,
  $memcached_max_connections = 8192,
  $memcached_unix_socket     = undef
) {

  class {'memcached':
    max_memory      => $memcached_max_memory,
    lock_memory     => $memcached_lock_memory,
    listen_ip       => $memcached_listen_ip,
    tcp_port        => $memcached_tcp_port,
    udp_port        => $memcached_udp_port,
    max_connections => $memcached_max_connections,
    unix_socket     => $memcached_unix_socket,
  }

  package {['libapache2-mod-mapcache', 'mapcache-tools']:
    ensure => present,
  }

  apache::module {'mapcache':
    ensure  => present,
    require => Package['libapache2-mod-mapcache'],
  }
}
