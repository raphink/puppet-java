class generic-tmpl::mw::puppetdb::server (
  $server,
  $cert_source,
  $key_source,
  $trust_password,
  $key_password,
  $postgresql_version,
  $max_mem='1024m',
  $monitoring=true,
  $database_name='puppetdb',
  $database_username='puppetdb',
  $database_password='puppetdb',
  $postgresql_base_dir=undef,
  $postgresql_backup_dir=undef,
  $postgresql_backup_format=undef,
) {
  file {
    "/var/cache/java_keys/${server}.crt":
      ensure => present,
      source => $cert_source,
      before => Class['puppetdb::ssl'];

    "/var/cache/java_keys/${server}.key":
      ensure => present,
      source => $key_source,
      before => Class['puppetdb::ssl'];
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

  class {'::generic-tmpl::mw::java::v6':
    before => Class['::puppetdb::server'],
  }

  class { '::generic-tmpl::mw::postgresql':
    version       => $postgresql_version,
    base_dir      => $postgresql_base_dir,
    backup_dir    => $postgresql_backup_dir,
    backup_format => $postgresql_backup_format,
  }

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
