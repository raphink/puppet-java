class generic-tmpl::mw-devel {

  package {
    "ack-grep":      ensure => present; # a grep replacement
    "ipython":       ensure => present; # interactive python shell
    "libxml2-utils": ensure => present; # xml utilities
    "pyflakes":      ensure => present; # python static code checker
    "pylint":        ensure => present; # python static code checker
  }

}
