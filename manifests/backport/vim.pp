class generic-tmpl::backport::vim {

  case $::lsbdistcodename {
    'squeeze': {
      apt::preferences { ['vim', 'vim-common', 'vim-runtime', 'vim-tiny']:
        ensure   => present,
        pin      => 'release o=Camptocamp',
        priority => 1001,
      }
    }
    'wheezy': {
      debug ('No backporting vim on wheezy. Default version is fine.')
    }
    default: {
      fail "${name} doesn't support ${::operatingsystem} ${::lsbdistcodename}"
    }
  }

}
