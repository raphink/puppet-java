class generic-tmpl::backport::vim {
  if $::lsbdistcodename == 'squeeze' {
    apt::preferences { ['vim', 'vim-common', 'vim-runtime', 'vim-tiny']:
      ensure   => present,
      pin      => 'release o=Camptocamp',
      priority => 1001,
    }
  }
}
