class generic-tmpl::mw::rsyncd {

  include rsyncd

  file { "/etc/rsyncd.secrets":
    mode   => 0600,
    owner  => "root",
    group  => "root",
  }

  generic-tmpl::mw::augeas::lens { 'htpasswd': }
}
