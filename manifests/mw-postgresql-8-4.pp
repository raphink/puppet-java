class generic-tmpl::mw-postgresql-8-4 {

  include postgresql::v8-4
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
