class generic-tmpl::mw-puppet-master-ecosystem {

  include githubsync::dashboard
  include githubsync::nagios
  include git-subtree
  include puppet::lint

  motd::message { "zzz-githubsync-status":
    source  => "file:///var/local/run/githubsync/current-status.txt",
    require => File["/var/local/run/githubsync/current-status.txt"],
  }

  archive::download {'puppetstoredconfigclean':
    url      => 'https://raw.github.com/puppetlabs/puppet/master/ext/puppetstoredconfigclean.rb',
    checksum => false,
    src_target => '/usr/local/bin',
  }

  file {'/usr/local/bin/puppetstoredconfigclean':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    require => Archive::Download['puppetstoredconfigclean'],
  }

  file { "/var/local/run/githubsync/.netrc":
    mode    => 0600,
    owner   => "githubsync",
    group   => "githubsync",
    before  => File["/usr/local/bin/githubsync-update-status.sh"],
    content => '# file managed by puppet
machine github.com
login c2c-modules-subtree-sync
password paipah6Icose1aeD
',
  }

  monitoring::check { "GitHub sync":
    ensure   => present,
    codename => "check_github_module_sync",
    command  => "check-github-module-sync.sh",
    base     => "/var/local/run/githubsync/nagios-plugins/",
    type     => "passive",
    interval => "60", # once an hour
    retry    => "60", # once an hour
    server   => $nagios_nsca_server,
    server_tag => $nagios_nsca_export_for ? {
      "" => false,
      default => $nagios_nsca_export_for
    },
    require   => Class["githubsync::nagios"],
  }

  file { "/var/local/run/githubsync/.ssh":
    ensure  => absent,
    purge   => true,
    force   => true,
    recurse => true,
  }

}
