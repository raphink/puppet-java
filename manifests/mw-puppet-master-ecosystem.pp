class generic-tmpl::mw-puppet-master-ecosystem (
  $report_log_retention = '5d',
  $puppetmasters = '4',
  $backend_name = 'puppetmaster-default',
  $dbhost = 'localhost',
  $dbname = 'puppet',
  $dbuser = 'puppet',
  $dbpassword   = 'puppet',
  $dbconnections = '20',
  $ca = false,
  $ssldir = '',
  $certname = '',
  $reports = 'store,log,irc',
  $foreman_url = "https://${::fqdn}",
) {

  include githubsync
  include git-subtree
  include puppet::lint
  include generic-tmpl::mw-git

  if $::operatingsystem == 'RedHat' and versioncmp($::lsbdistrelease, '6.0') >= 0 {
    $dbadapter = 'mysql2'
  }
  else {
    $dbadapter = 'mysql'
  }

  class {'::puppet::master::standalone::plain':
    puppetmasters => $puppetmasters,
    backend_name  => $backend_name,
    dbadapter     => $dbadapter,
    dbhost        => $dbhost,
    dbname        => $dbname,
    dbuser        => $dbuser,
    dbpassword    => $dbpassword,
    dbconnections => $dbconnections,
    ca            => $ca,
    ssldir        => $ssldir,
    certname      => $certname,
  }

  class {'::puppet::database::mysql':
    dbname        => $dbname,
    dbuser        => $dbuser,
    dbpassword    => $dbpassword,
  }

  motd::message { 'zzz-githubsync-status':
    source  => 'file:///var/local/run/githubsync/current-status.txt',
  }

  user { 'githubsync':
    ensure  => present,
    shell   => '/bin/sh',
    home    => '/var/local/run/githubsync',
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
    'stable27':   path => '/srv/puppetmaster/stable', ensure  => absent;
    'staging':    path => '/srv/puppetmaster/staging';
    'staging27':  path => '/srv/puppetmaster/staging', ensure => absent;
    'foreman':    path => '/srv/puppetmaster/foreman';
    'marc':       path => '/home/marc';
    'mbornoz':    path => '/home/mbornoz';
    'cjeanneret': path => '/home/cjeanneret';
    'ckaenzig':   path => '/home/ckaenzig';
    'mremy':      path => '/home/mremy';
    'rpinson':    path => '/home/rpinson';
    'mcanevet':   path => '/home/mcanevet';
    'illambias':  path => '/home/illambias';
    'jbove':      path => '/home/jbove';
    'francois':   path => '/home/francois';
  }

  Puppet::Config {
    notify => Service['puppetmaster'],
  }

  puppet::config { 'master/reports': value => $reports }

  tidy { '/var/lib/puppet/reports':
    age     => $report_log_retention,
    type    => 'ctime',
    recurse => true,
    backup  => false,
    matches => '*.yaml',
  }

  cron { 'update githubsync status':
    ensure  => present,
    command => "/usr/local/bin/githubsync.sh https camptocamp ${origin} 2>&1 | logger -t githubsync",
    user    => 'githubsync',
    hour    => '3',
    minute  => fqdn_rand(60),
    require => [Class['githubsync']],
  }

  file { '/var/local/run/githubsync/.netrc':
    mode    => '0600',
    owner   => 'githubsync',
    group   => 'githubsync',
    before  => File['/usr/local/bin/githubsync.sh'],
    require => User['githubsync'],
    content => '# file managed by puppet
machine github.com
login c2c-modules-subtree-sync
password paipah6Icose1aeD
',
  }

  file {'/var/local/run/githubsync/.gitconfig':
    mode    => '0644',
    owner   => 'githubsync',
    group   => 'githubsync',
    require => User['githubsync'],
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
    mode    => '0755',
  }

  augeas { 'remove legacy puppetmasterd section':
    lens    => 'Puppet.lns',
    incl    => '/etc/puppet/puppet.conf',
    changes => [
      'rm puppetmasterd',
      'rm puppetca',
    ],
  }

  if $::operatingsystem =~ /Debian|Ubuntu/ {
    package { ['puppet-el', 'vim-puppet']: ensure => present }

    apt::preferences {[
        'puppetmaster',
        'puppetmaster-common',
        'puppet-el',
        'puppet-testsuite',
        'vim-puppet'
      ]:
      ensure   => present,
      pin      => "release o=Camptocamp, n=${::lsbdistcodename}",
      priority => 1100,
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
:github_user: c2c-irc-reports
:github_password: uedieshi7phaeX3
",
    notify  => Service['puppetmaster'],
    require => Package['carrier-pigeon', 'addressable'],
  }

  file { '/etc/puppet/foreman.yaml':
    ensure  => present,
    content => "---
:foreman_url: '${foreman_url}'
",
    notify  => Service['puppetmaster'],
  }

  file { '/usr/local/bin/git-irc-hook.sh':
    source => 'puppet:///modules/generic-tmpl/git-irc-hook.sh',
    mode   => '0755',
  }

  sshd_config { 'AcceptEnv':
    value  => ['LANG', 'LC_*', 'STOMP_USER', 'STOMP_PASSWORD'],
  }

  ::puppet::config_version::git { 'default': }

}
