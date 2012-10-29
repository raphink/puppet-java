class generic-tmpl::mw-puppet-master-ecosystem {

  include githubsync
  include git-subtree
  include puppet::lint

  if $::operatingsystem and versioncmp($::lsbdistrelease, '6.0') >= 0 {
    $puppetdbtype = 'mysql2'
  }
  else {
    $puppetdbtype = 'mysql'
  }
  $puppetdbhost = 'localhost'
  $puppetdbname = 'puppet'
  $puppetdbuser = 'puppet'
  $puppetdbpw   = 'puppet'
  $puppetdbconnections = '20'
  $ca_root      = '/srv/puppetca'
  include puppet::master::mongrel::plain
  include puppet::database::mysql

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

  puppet::config { 'master/reports': value => 'store,log,irc' }

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

  augeas { 'remove legacy puppetmasterd section':
    lens    => 'Puppet.lns',
    incl    => '/etc/puppet/puppet.conf',
    changes => [
      'rm puppetmasterd',
      'rm puppetca',
    ],
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

  package { 'carrier-pigeon':
    ensure => present,
    name => $::operatingsystem ? {
      'RedHat' => 'carrier-pigeon',
      'Debian' => 'ruby-carrier-pigeon',
    },
    provider => $::operatingsystem ? {
      'RedHat' => 'gem',
      'Debian' => 'apt',
    },
  }

  package { 'addressable':
    ensure => present,
    name => $::operatingsystem ? {
      'RedHat' => 'addressable',
      'Debian' => 'libaddressable-ruby',
    },
    provider => $::operatingsystem ? {
      'RedHat' => 'gem',
      'Debian' => 'apt',
    },
  }

  file { '/etc/puppet/irc.yaml':
    ensure  => present,
    content => "---
:irc_server: 'irc://${::hostname}@irc.geeknode.org:6667#c2c-sysadmin'
:irc_ssl: false
:irc_register_first: false
:irc_join: false
",
    notify  => Service['puppetmaster'],
    require => Package['carrier-pigeon', 'addressable'],
  }

}
