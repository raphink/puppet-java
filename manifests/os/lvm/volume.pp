define generic-tmpl::os::lvm::volume (
  $size,
  $pv,
  $ensure    = 'present',
  $vg        = 'vg0',
  $fstype    = 'ext4',
  $mountpath = '',
  $pass      = 2,
  $dump      = 1
  ) {

  $_mountpath = $mountpath ? {
    ''      => "/${name}",
    default => $mountpath,
  }

  if !defined(Physical_volume[$pv]) {
    physical_volume { $pv:
      ensure => present
    }
  }

  if !defined(Volume_group[$vg]){
    volume_group { $vg:
      ensure           => present,
      physical_volumes => $pv,
      require          => Physical_volume[$pv],
    }
  }

  logical_volume { $name:
    ensure       => present,
    volume_group => $vg,
    size         => $size,
    require      => Volume_group[$vg],
  }

  filesystem {"/dev/${vg}/${name}":
    ensure  => present,
    fs_type => $fstype,
    require => Logical_volume[$name],
  }

  mount { $_mountpath:
    ensure  => mounted,
    device  => "/dev/${vg}/${name}",
    fstype  => $fstype,
    options => 'defaults',
    pass    => $pass,
    dump    => $dump,
    atboot  => true,
    require => Filesystem["/dev/${vg}/${name}"],
  }

}

