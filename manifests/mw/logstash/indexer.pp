class generic-tmpl::mw::logstash::indexer (
  $apache_vhost_name,
  $apache_vhost_aliases,
  $logstash_input_file,
  $logstash_filter_file,
  $logstash_output_file,
  $es_service_settings = undef,
  $es_index_retention_days = 30,
  $java16_vendor = 'openjdk',
  $logstash_java_opts = '-Xms1g -Xmx1g',
  $logstash_instance = 'indexer',
  $kibana_git_revision = '41a12980eea9ebc751a83b8b95d378fb1b64fb12',
  $kibana_base_port = 5601,
  $kibana_server_number = 4,
) {

  include ::java
  include ::rabbitmq::server
  include ::logstash
  include ::ruby::gems
  include ::apache::ssl

  logstash::instance{$logstash_instance:
    ensure      => present,
    input_file  => $logstash_input_file,
    filter_file => $logstash_filter_file,
    output_file => $logstash_output_file,
    java_opts   => $logstash_java_opts
  }

  class {'::elasticsearch':
    service_settings => $es_service_settings,
    config           => {
      'cluster.name'                         => 'elasticsearch',
      'bootstrap.mlockall'                   => true,
      'network.bind_host'                    => '127.0.0.1',
      'network.publish_host'                 => '127.0.0.1',
      'network.host'                         => '127.0.0.1',
      'discovery.zen.ping.multicast.enabled' => false
    }
  }

  class {'::kibana':
    package_type => 'gem',
    thin_servers => $kibana_server_number,
    git_revision => $kibana_git_revision,
  }

  class {'::thin': package_type => 'gem'}
  apache::module {['proxy', 'proxy_http', 'headers']: ensure => present }

  apache::vhost::ssl {$apache_vhost_name:
    aliases => $apache_vhost_aliases,
    sslonly => true,
  }

  apache::balancer {'kibana':
    location => '/',
    vhost    => $apache_vhost_name,
    members  => split(inline_template("<%= (${kibana_base_port}..${kibana_base_port}+(${kibana_server_number}-1)).to_a.collect{|x| 'localhost:'+x.to_s}.join(',') %>"),',')
  }

  # package required by the script logstash_index_cleaner.py
  include ::python::pip
  include ::python::pip::pyes
  include ::python::package::argparse
  include ::python::package::ordereddict
  Package <| alias == 'python-pyes' |>
  Package <| alias == 'python-argparse' |>
  Package <| alias == 'python-ordereddict' |>

  file {'/usr/local/bin/logstash_index_cleaner.py':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '2775',
    source  => "puppet:///modules/${module_name}/logstash/logstash_index_cleaner.py",
    require => Package['python-pyes','python-argparse'],
  }

  cron {'clean_old_elasticsearch_indexes':
    command => "/usr/local/bin/logstash_index_cleaner.py -d ${es_index_retention_days}",
    minute  => 5,
    hour    => 2,
    require => File['/usr/local/bin/logstash_index_cleaner.py'],
  }

}
