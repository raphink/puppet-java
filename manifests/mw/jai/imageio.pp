class generic-tmpl::mw::jai::imageio {
  include ::generic-tmpl::mw::jai
  case $::osfamily {
    'Debian': {
      package { 'libjai-imageio-core-java': }

      apt::preferences {'java-jai-imageio':
        package  => 'libjai-imageio-core-java libjai-imageio-core-java-doc',
        pin      => 'release o=Camptocamp',
        priority => '1100',
      }
    }

    default: {
      fail "Unsupported OS family ${::osfamily}"
    }
  }
}
