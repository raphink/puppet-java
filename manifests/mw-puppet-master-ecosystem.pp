class generic-tmpl::mw-puppet-master-ecosystem {

  include githubsync::dashboard
  include git-subtree

  motd::message { "zzz-githubsync-status":
    source  => "file:///var/local/run/githubsync/current-status.txt",
    require => File["/var/local/run/githubsync/current-status.txt"],
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

  file { "/var/local/run/githubsync/.ssh":
    ensure  => absent,
    purge   => true,
    force   => true,
    recurse => true,
  }

}
