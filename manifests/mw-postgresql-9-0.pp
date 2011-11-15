class generic-tmpl::mw-postgresql-9-0 {

  # avoid partial configuration on untested-distribution
  if $lsbdistcodename !~ /^squeeze$/ {
    fail "${name} not tested on ${operatingsystem}/${lsbdistcodename}"
  }

  include postgresql::v9-0
  include postgresql::administration

  if !defined(Package["python-psycopg2"]) {
        package {"python-psycopg2": 
          ensure => present,
        }
  }

  apt::preferences {'libpq-dev':
    pin      => 'release a=squeeze-backports',
    priority => '1100',
  }

  package {"postgresql-plperl-9.0":
    ensure => present,
  }

}
