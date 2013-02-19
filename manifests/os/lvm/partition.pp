define generic-tmpl::os::lvm::partition (
  $volume_group,
  $logical_volumes
){

  if has_key($logical_volumes[$name], 'ensure') {
    $_ensure = $logical_volumes[$name]['ensure']
  } else {
    $_ensure = 'present'
  }

  if has_key($logical_volumes[$name], 'fs_type') {
    $_fs_type = $logical_volumes[$name]['fs_type']
  } else {
    $_fs_type = 'ext4'
  }

  if has_key($logical_volumes[$name], 'options') {
    $_options = $logical_volumes[$name]['options']
  } else {
    $_options = 'defaults'
  }

  if has_key($logical_volumes[$name], 'size') {
    $_size = $logical_volumes[$name]['size']
  }

  if has_key($logical_volumes[$name], 'mountpath') {
    $_mountpath = $logical_volumes[$name]['mountpath']
  } else {
    $_mountpath = "/${name}"
  }

  if has_key($logical_volumes[$name], 'mountpath_require') {
    if str2bool($logical_volumes[$name]['mountpath_require']) {
      Mount {
        require => File[$_mountpath],
      }
    }
  }

  $mount_ensure = $_ensure ? {
    'absent'  => absent,
    default   => mounted,
  }

  if $_ensure == 'present' {
    Logical_volume[$name] ->
    Filesystem["/dev/${volume_group}/${name}"] ->
    Mount[$_mountpath]
  } else {
    Mount[$_mountpath] ->
    Filesystem["/dev/${volume_group}/${name}"] ->
    Logical_volume[$name]
  }

  logical_volume {$name:
    ensure       => $_ensure,
    volume_group => $volume_group,
    size         => $_size,
  }

  filesystem {"/dev/${volume_group}/${name}":
    ensure  => $_ensure,
    fs_type => $_fs_type,
  }

  mount {$_mountpath:
    ensure  => $mount_ensure,
    device  => "/dev/${volume_group}/${name}",
    fstype  => $_fs_type,
    options => $_options,
    pass    => 2,
    dump    => 1,
    atboot  => true,
  }

}
