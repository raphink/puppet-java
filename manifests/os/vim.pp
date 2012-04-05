class generic-tmpl::os::vim {
  $vim_pkgs = $::operatingsystem ? {
    /Debian|Ubuntu/ => ['vim', 'vim-common', 'vim-runtime', 'vim-tiny'],
    /RedHat|CentOS/ => 'vim',
    default => undef
  }

  if $vim_pkgs {
    package {$vim_pkgs:
      ensure => latest,
    }
    if $::lsbdistcodename == 'squeeze' {
      apt::preferences {$vim_pkgs:
        ensure   => present,
        pin      => 'release o=Camptocamp',
        priority => 1001,
      }
    }
  }
}
