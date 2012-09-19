class generic-tmpl::mw::postgresql::v8-4 {

  $postgresql_version = '8.4'

  include postgresql
  include postgresql::backup
  include postgresql::administration

  if $lsbdistcodename == 'lenny' {
    apt::preferences {'libpq-dev':
      pin => 'release o=Camptocamp',
      priority => 1100,
    } 
  } 

  if !defined(Package["python-psycopg2"]) {
    package {"python-psycopg2": 
      ensure => present,
    }
  }

  package {"postgresql-plperl-8.4":
    ensure => present,
  }

}
