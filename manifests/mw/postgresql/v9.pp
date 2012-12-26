class generic-tmpl::mw::postgresql::v9 (
  $version = $postgresql_version,
) {

  # avoid partial configuration on untested-distribution
  if $::lsbdistcodename !~ /^(squeeze|wheezy)$/ {
    fail "${name} not tested on $::operatingsystem/$::lsbdistcodename"
  }

  if $version == '' {
    $version = '9.0'
  }

  include postgresql
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
