class generic-tmpl::mw-postgresql-8-4 {

  include postgresql::v8-4
  include postgresql::administration

  if !defined(Package["python-psycopg2"]) {
        package {"python-psycopg2": 
          ensure => present,
        }
  }


}
