class generic-tmpl::mw::compass {
  package {'libcompass-ruby1.8':
    ensure  => latest,
    require => Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"],
  }

  apt::preferences {'compass':
    ensure   => present,
    package  => 'libcompass-ruby1.8',
    pin      => 'release o=Camptocamp',
    priority => '1100',
  }
}
