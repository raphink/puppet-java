class generic-tmpl::mw::jai {
  case $::osfamily {
    'Debian': {
      package { 'libjai-core-java': }

      apt::preferences {'java-jai':
        package  => 'libjai-core-java libjai-core-java-doc',
        pin      => 'release o=Camptocamp',
        priority => '1100',
      }
    }

    default: {
      fail "Unsupported OS family ${::osfamily}"
    }
  }
}
