class generic-tmpl::mw-devel {

  package {
    "ipython":       ensure => present; # interactive python shell
    "libxml2-utils": ensure => present; # xml utilities
    "pyflakes":      ensure => present; # python static code checker
    "pylint":        ensure => present; # python static code checker
    'pep8':          ensure => present; # yet another static code checker
    'colordiff':     ensure => present; # tool to colorize 'diff' output
    'virtualenvwrapper': ensure => present;
  }

  if $::lsbdistcodename == 'squeeze' {
    # tmux from squeeze backports
    apt::preferences {'tmux':
      pin      => 'release a=squeeze-backports',
      priority => 1100,
    }
    package {'tmux':
      ensure => present,
    }
  }

}
