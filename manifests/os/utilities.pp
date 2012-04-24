class generic-tmpl::os::utilities {
  package {[
    'tree',
    'ack-grep',
    ]:
    ensure => present,
  }
}
