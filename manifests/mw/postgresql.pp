class generic-tmpl::mw::postgresql (
  $version,
  $base_dir = undef,
  $backup = present,
  $backup_dir = undef,
  $backup_format = undef,
) {

  class {'::postgresql':
    version    => $version,
    base_dir   => $base_dir,
  }

  class {'::postgresql::backup':
    ensure        => $backup,
    backup_dir    => $backup_dir,
    backup_format => $backup_format,
  }

  include ::postgresql::administration

  if !defined(Package['python-psycopg2']) {
    package {'python-psycopg2':
      ensure => present,
    }
  }

  $plperl_pkg_name = $::osfamily ? {
    RedHat => $::lsbmajdistrelease ? {
      5    => 'postgresql84-plperl',
      6    => 'postgresql-plperl',
      },
    default => "postgresql-plperl-${version}",
  }
  package {"postgresql-plperl-${version}":
    ensure => present,
    name   => $plperl_pkg_name,
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
