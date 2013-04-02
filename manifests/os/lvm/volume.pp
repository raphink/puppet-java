define generic-tmpl::os::lvm::volume (
  $size,
  $options           = undef,
  $ensure            = present,
  $fs_type           = 'ext4',
  $volume_group      = 'vg0',
  $mountpath         = "/${name}",
  $mountpath_require = false,
){

  validate_bool($mountpath_require)

  if $mountpath_require {
    Mount {require => File[$mountpath]}
  }

  $mount_ensure = $ensure ? {
    'absent'  => absent,
    default   => mounted,
  }

  if $ensure == 'present' {
    Logical_volume[$name] ->
    Filesystem["/dev/${volume_group}/${name}"] ->
    Mount[$mountpath]
  } else {
    Mount[$mountpath] ->
    Filesystem["/dev/${volume_group}/${name}"] ->
    Logical_volume[$name]
  }

  logical_volume {$name:
    ensure       => $ensure,
    volume_group => $volume_group,
    size         => $size,
  }

  filesystem {"/dev/${volume_group}/${name}":
    ensure  => $ensure,
    fs_type => $fs_type,
  }

  mount {$mountpath:
    ensure  => $mount_ensure,
    device  => "/dev/${volume_group}/${name}",
    fstype  => $fs_type,
    options => $options,
    pass    => 2,
    dump    => 1,
    atboot  => true,
  }

}
