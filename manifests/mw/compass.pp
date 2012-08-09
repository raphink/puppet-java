class generic-tmpl::mw::compass {
  package {'libcompass-ruby1.8':
    ensure  => present,
    require => Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sig"],
  }
}
