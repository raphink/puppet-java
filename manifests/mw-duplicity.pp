class generic-tmpl::mw-duplicity {
  include duplicity
  $check_backup_type = 'duplicity'
  include monitoring::backup
}
