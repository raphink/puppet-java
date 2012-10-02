class generic-tmpl::mw::mcollective::node {
  include ::mcollective::node

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
        package  => 'mcollective mcollective-common mcollective-client mcollective-doc',
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
