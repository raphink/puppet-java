# == Define: generic-tmpl::os::lvm
#
# Simple wrapper LVM pour gérer les cas standards
#
# === Objectif
#
# Avoir une déclaration simple et concise basée sur un hash de hash
# pour la liste des partitions (logical volumes).
#
# === Exemples
#
# Cas standard (installation kickstart/preseed):
#
#  generic-tmpl::os::lvm {'vg0':
#    physical_volumes => ['/dev/sda2', '/dev/sda3'],
#    logical_volumes  => {
#      'opt'    => {'size' => '20G'},
#      'tmp'    => {'size' => '1G' },
#      'usr'    => {'size' => '3G' },
#      'var'    => {'size' => '15G'},
#      'home'   => {'size' => '5G' },
#      'backup' => {
#        'size'              => '5G',
#        'mountpath'         => '/var/backups',
#        'mountpath_require' => true
#      }
#    }
#  }
#
# === Remarques
#
#  Chaque partition (logical_volume) est définie par un hash dont le seul
#  paramètres obligatoire est 'size'.
#
#  Les autres valeures par défaut actuellement supportées sont:
#
#    'name'                => {
#      'size'              => '10G', #mandatory
#      'ensure'            => 'present',
#      'fs_type'           => 'ext4',
#      'options'           => 'defaults',
#      'mountpath'         => "/${name}",
#      'mountpath_require' => false
#    }
#
define generic-tmpl::os::lvm (
  $logical_volumes,
  $physical_volumes,
  $ensure = present,
){

  validate_array($physical_volumes)
  validate_hash($logical_volumes)

  physical_volume {$physical_volumes: ensure => $ensure}

  volume_group {$name:
    ensure           => $ensure,
    physical_volumes => $physical_volumes,
    require          => Physical_volume[$physical_volumes],
  }

  Generic-tmpl::Os::Lvm::Partition {volume_group => $name}
  create_resources(generic-tmpl::os::lvm::volume, $logical_volumes)

}

