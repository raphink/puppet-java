class generic-tmpl::mw-puppet-master-ecosystem {

  include githubsync::dashboard
  include git-subtree

  motd::message { "zzz-githubsync-status":
    source  => "file:///var/local/run/githubsync/current-status.txt",
    require => File["/var/local/run/githubsync/current-status.txt"],
  }

}
