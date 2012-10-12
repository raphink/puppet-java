class generic-tmpl::mw-puppet-master-ecosystem {

  include githubsync
  include git-subtree
  include puppet::lint

  $puppetdbtype = 'mysql'
  include puppet::master::mongrel::plain

  motd::message { "zzz-githubsync-status":
    source  => "file:///var/local/run/githubsync/current-status.txt",
  }

  user { "githubsync":
    ensure  => present,
    shell   => "/bin/sh",
    home    => "/var/local/run/githubsync",
    #TODO: fix this stupid discrepency !
    groups  => $::domain ? {
      /epfl\.ch$/          => ['admin-puppetmaster'],
      /compute\.internal$/ => ['puppet-admin'],
      /camptocamp\.com$/   => ['sysadmin'],
      /bl\.ch/             => ['puppet-admin'],
    },
  }

  #TODO: fix this stupid discrepency !
  $origin = $::domain ? {
    /compute\.internal$/ => '/srv/puppetmaster/staging/',
    /camptocamp\.com$/   => '/srv/puppetmaster/staging/',
    /bl\.ch/             => '/srv/puppetmaster/staging/puppetmaster/',
    /epfl\.ch/           => '/srv/puppetmaster/staging/puppetmaster/',
  }

  puppet::environment {
    'stable':     path => '/srv/puppetmaster/stable';
    'staging':    path => '/srv/puppetmaster/staging';
    'marc':       path => '/home/marc';
    'mbornoz':    path => '/home/mbornoz';
    'cjeanneret': path => '/home/cjeanneret';
    'ckaenzig':   path => '/home/ckaenzig';
    'mremy':      path => '/home/mremy';
    'rpinson':    path => '/home/rpinson';
    'illambias':  path => '/home/illambias';
    'jbove':      path => '/home/jbove';
  }

  Puppet::Config {
    notify => Service['puppetmaster'],
  }

  puppet::config {
   'master/reports':    value => 'store log irc';
   'master/dbserver':   value => 'localhost';
   'master/dbuser':     value => 'puppet';
   'master/dbpassword': value => 'puppet';
   'master/dbadapter':  value => 'mysql';
   'master/dbsocket':   value => '/var/lib/mysql/mysql.sock';
  }

  cron { 'update githubsync status':
    command => "/usr/local/bin/githubsync.sh https camptocamp ${origin} 2>&1 | logger -t githubsync",
    ensure  => present,
    user    => 'githubsync',
    hour    => '3',
    minute  => fqdn_rand(60),
    require => [Class["githubsync"]],
  }

  file { "/var/local/run/githubsync/.netrc":
    mode    => 0600,
    owner   => "githubsync",
    group   => "githubsync",
    before  => File["/usr/local/bin/githubsync.sh"],
    require => User["githubsync"],
    content => '# file managed by puppet
machine github.com
login c2c-modules-subtree-sync
password paipah6Icose1aeD
',
  }

  file { "/var/local/run/githubsync/.gitconfig":
    mode    => 0644,
    owner   => "githubsync",
    group   => "githubsync",
    require => User["githubsync"],
    content => '# file managed by puppet
[user]
  name = githubsync friendly robot
  email = sysadmin@camptocamp.com
',
  }

  file {'/usr/local/bin/puppetstoredconfigclean.rb':
    ensure  => present,
    source  => 'puppet:///modules/generic-tmpl/puppet/puppetstoredconfigclean.rb',
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
  }

  if (versioncmp($::puppetversion, 2) > 0) {
    augeas { 'remove legacy puppetmasterd section':
      lens    => 'Puppet.lns',
      incl    => '/etc/puppet/puppet.conf',
      changes => 'rm puppetmasterd',
    }
  }

  case $operatingsystem {
    /Debian|Ubuntu/: {

      package { ['puppet-el', 'vim-puppet']: ensure => present }

      apt::preferences {['puppetmaster', 'puppetmaster-common', 'puppet-el', 'puppet-testsuite', 'vim-puppet']:
        ensure   => present,
        pin      => "release o=Camptocamp, n=${lsbdistcodename}",
        priority => 1100,
      }
    }
  }
}
