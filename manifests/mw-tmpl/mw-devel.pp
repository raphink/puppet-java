class generic-tmpl::mw-devel {

  # interactive python shell
  package {"ipython":
    ensure => present,
  }

  # python static code checker
  package {["pyflakes", "pylint"]:
    ensure => present,
  }

  # xml utilities
  package {"libxml2-utils":
    ensure => present,
  }
}
