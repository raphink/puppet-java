class generic-tmpl::mw::mcollective::node (
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
  $security_ssl_private = undef,
  $security_ssl_public = undef,
  $rpcauthorization = undef,
  $rpcauthprovider = undef,
) {

  class { '::mcollective::node':
    broker_host          => $broker_host,
    broker_port          => $broker_port,
    broker_user          => $broker_user,
    broker_password      => $broker_password,
    broker_ssl           => $broker_ssl,
    broker_ssl_cert      => $broker_ssl_cert,
    broker_ssl_key       => $broker_ssl_key,
    broker_ssl_ca        => $broker_ssl_ca,
    security_provider    => $security_provider,
    security_secret      => $security_secret,
    security_ssl_private => $security_ssl_private,
    security_ssl_public  => $security_ssl_public,
    rpcauthorization     => $rpcauthorization,
    rpcauthprovider      => $rpcauthprovider,
  }

  $agents = [
    'augeasquery',
    'filemgr',
    'nettest',
    'nrpe',
    'package',
    'process',
    'puppetd',
    'service',
    'stomputil',
    ]

  case $::operatingsystem {
    /Debian|Ubuntu/: {

      apt::preferences {'mcollective':
        package  => 'mcollective mcollective-common mcollective-client mcollective-doc ruby-stomp',
        pin      => 'release o=Camptocamp',
        priority => '1100',
      }

      # Let them upgrade
      apt::preferences {'mcollective-agents':
        # Lenny machines don't recognize glob()
        package  => inline_template('mcollective-agent-<%= agents.join(" mcollective-agent-") %>'),
        pin      => 'release o=Camptocamp',
        priority => '1100',
      }

      # Until mcollective includes it by default
      package {'mcollective-plugins-uapt':
        ensure  => present,
        notify  => Exec['reload mcollective'],
      }

      apt::preferences {'mcollective-plugins-uapt':
        pin      => 'release o=Camptocamp',
        priority => '1100',
      }

      apt::preferences {'mcollective-puppetcert-agent':
        pin      => 'release o=Camptocamp',
        priority => '1100',
      }
    }

    default: { }
  }

  # FIXME: this package was built by "mco plugin package" and doesn't match the
  # name mcollective::plugin expects.
  package {'mcollective-puppetcert-agent':
    ensure  => present,
    notify  => Exec['reload mcollective'],
  }

  mcollective::plugin { $agents:
    ensure => present,
  }

}
