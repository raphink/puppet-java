class generic-tmpl::mw::postgresql::9 {

  # avoid partial configuration on untested-distribution
  if $::lsbdistcodename !~ /^squeeze$/ {
    fail "${name} not tested on $::operatingsystem/$::lsbdistcodename"
  }

  $version = $postgresql_version ? {
    ''      => '9.0',
    default => $postgresql_version
  }

  case $version {
    '9.0'   : { include postgresql::v9-0 }
    '9.1'   : { include postgresql::v9-1 }
    default : { fail "unsupported version ${version}" }
  }

  include postgresql::backup
  include postgresql::administration

  if !defined(Package['python-psycopg2']) {
    package {'python-psycopg2':
      ensure => present,
    }
  }

  apt::preferences {'libpq-dev':
    pin      => 'release a=squeeze-backports',
    priority => '1100',
  }

  package {"postgresql-plperl-${version}":
    ensure => present,
  }

}
