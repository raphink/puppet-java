class generic-tmpl::mw-puppet-master-ecosystem {

  include githubsync
  include git-subtree
  include puppet::lint

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

  # We provide packages for Puppet 0.25 only
  if $puppetmaster_legacy {
    case $operatingsystem {
      /Debian|Ubuntu/: {

        package { ['puppet-el', 'vim-puppet']: ensure => present }

        apt::preferences {['puppetmaster', 'puppet-el', 'puppet-testsuite', 'vim-puppet']:
          ensure   => present,
          pin      => "release o=Camptocamp, n=${lsbdistcodename}",
          priority => 1100,
        }
      }
    }
  }
}
