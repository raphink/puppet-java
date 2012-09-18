class generic-tmpl::mw-devel {

  package {
    "ipython":       ensure => present; # interactive python shell
    "libxml2-utils": ensure => present; # xml utilities
    "pyflakes":      ensure => present; # python static code checker
    "pylint":        ensure => present; # python static code checker
    'colordiff':     ensure => present; # tool to colorize 'diff' output
  }

}
