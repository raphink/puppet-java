class generic-tmpl::mw::postgresql::v8-3 (
  $version='8.3',
  $base_dir=$postgresql_base_dir,
  $backup_dir=$postgresql_backupdir,
  $backup_format=$postgresql_backupformat,
) {

  class {'::generic-tmpl::mw::postgresql':
    version       => $version,
    base_dir      => $base_dir,
    backup_dir    => $backup_dir,
    backup_format => $backup_format,
  }

}
