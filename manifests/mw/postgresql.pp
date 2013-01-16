class generic-tmpl::mw::postgresql (
  $version,
) {

  class {'::postgresql':
    version => $version,
  }

  include ::postgresql::backup
  include ::postgresql::administration

  if !defined(Package['python-psycopg2']) {
    package {'python-psycopg2':
      ensure => present,
    }
  }

  package {"postgresql-plperl-${version}":
    ensure => present,
  }

  if $lsbdistcodename =~ /lenny|squeeze/ {
    apt::preferences {'libpq-dev':
      pin      => "release o=Camptocamp",
      priority => '1100',
    }
  }

}
