class generic-tmpl::mw::puppetdb::server (
  $server,
  $cert_source,
  $key_source,
  $trust_password,
  $key_password,
  $max_mem='1024m',
  $monitoring=true,
  $database_name='puppetdb',
  $database_username='puppetdb',
  $database_password='puppetdb',
) {
  file {
    "/var/cache/java_keys/${server}.crt":
      ensure => present,
      source => $cert_source,
      before => Openssl::Export::Pkcs12[$server];

    "/var/cache/java_keys/${server}.key":
      ensure => present,
      source => $key_source,
      before => Openssl::Export::Pkcs12[$server];
  }

  class {'::puppetdb::server':
    ssl_listen_address => $server,
    trust_password     => $trust_password,
    key_password       => $key_password,
    puppet_ssldir      => '/var/lib/puppet/ssl',
    ssl_cert           => "/var/cache/java_keys/${server}.crt",
    ssl_private_key    => "/var/cache/java_keys/${server}.key",
    ssl_generate_key   => false,
    database_name      => $database_name,
    database_username  => $database_username,
    database_password  => $database_password,
    require            => [
      File["/var/cache/java_keys/${server}.crt"],
      File["/var/cache/java_keys/${server}.key"],
    ]
  }

  class {'::java::v6':
    before => Class['::puppetdb::server'],
  }

  include ::generic-tmpl::mw::postgresql::v9
  class { '::puppetdb::database::postgresql':
    database_name     => $database_name,
    database_username => $database_username,
    database_password => $database_password,
    before            => Class['::puppetdb::server']
  }

  augeas {'Limit PuppetDB memory usage':
    incl    => '/etc/default/puppetdb',
    lens    => 'Shellvars.lns',
    changes => "set JAVA_ARGS '\"-Xmx${max_mem} -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/puppetdb/puppetdb-oom.hprof\"'",
    notify  => Service['puppetdb'],
  }

  if $monitoring {
    include ::monitoring::puppet::puppetdb::process
  }
}
