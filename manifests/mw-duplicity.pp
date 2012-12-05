class generic-tmpl::mw-duplicity {
  include duplicity
  monitoring::check::backup {"duplicity on $::fqdn":
    type => 'duplicity',
  }
}
