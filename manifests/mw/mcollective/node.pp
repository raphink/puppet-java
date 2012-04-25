class generic-tmpl::mw::mcollective::node {
  include mcollective-in-5-minutes::mcollective::node

  case $::operatingsystem {
    /Debian|Ubuntu/: {
      # Can't get variable with hyphens
      $mcollective_agents = [
        'mcollective-agent-augeasquery',
        'mcollective-agent-filemgr',
        'mcollective-agent-nettest',
        'mcollective-agent-nrpe',
        'mcollective-agent-package',
        'mcollective-agent-process',
        'mcollective-agent-puppetd',
        'mcollective-agent-service',
        'mcollective-agent-stomputil',
        ]

      # Let them upgrade
      apt::preferences {'mcollective-agents':
        # Lenny machines don't recognize glob()
        package  => inline_template('<%= mcollective_agents.join(" ")  %>'),
        pin      => 'release o=Camptocamp',
        priority => '1100',
      }
    }

    default: { }
  }
}
