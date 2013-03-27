class generic-tmpl::mw::postgresql (
  $version,
  $base_dir = undef,
  $backup_dir = undef,
  $backup_format = undef,
) {

  class {'::postgresql':
    version    => $version,
    base_dir   => $base_dir,
  }

  class {'::postgresql::backup':
    backup_dir    => $backup_dir,
    backup_format => $backup_format,
  }

  include ::postgresql::administration

  if !defined(Package['python-psycopg2']) {
    package {'python-psycopg2':
      ensure => present,
    }
  }

  package {"postgresql-plperl-${version}":
    ensure => present,
  }

  if $::lsbdistcodename =~ /lenny|squeeze/ {
    apt::preferences {['libpq-dev']:
      pin      => 'release o=Camptocamp',
      priority => '1100',
    }
  }

  if  ($::operatingsystem != 'RedHat' or $::lsbmajdistrelease > 4)
     and ($::operatingsystem != 'Debian' or $::lsbmajdistrelease > 5) {
    package {'pgtune':
      ensure => present,
    }
  }

}
