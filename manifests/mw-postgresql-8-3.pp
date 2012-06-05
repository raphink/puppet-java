class generic-tmpl::mw-postgresql-8-3 {

  include postgresql::v8-3
  include postgresql::backup
  include postgresql::administration

  if !defined(Package["python-psycopg2"]) {
    package {"python-psycopg2":
      ensure => present,
    }
  }

  package {"postgresql-plperl-8.3":
    ensure => present,
  }

}
