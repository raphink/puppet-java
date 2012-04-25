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

      # Let them upgrade
      apt::preferences {'mcollective-agents':
        # Lenny machines don't recognize glob()
        package  => inline_template('mcollective-agent-<%= agents.join(" mcollective-agent-") %>'),
        pin      => 'release o=Camptocamp',
        priority => '1100',
      }
    }

    default: { }
  }

  # Ensure mcollective is only running once
  exec {'Avoid multiple mcollectived':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => 'pkill -f mcollectived',
    onlyif  => 'test `pgrep -f [m]collectived | wc -l` -gt 1',
    notify  => Service['mcollective'],
  }

  mcollective::plugin { $agents:
    ensure => present,
  }
}
