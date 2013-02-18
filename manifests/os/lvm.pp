# == Class: generic-tmpl::os::lvm
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
#  class {'generic-tmpl::os::lvm':
#    volume_group     => 'vg0',
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
#        'mountpath_require' => 'true'
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
#      'size'              => 'xG', #mandatory
#      'ensure'            => 'present',
#      'fs_type'           => 'ext4',
#      'options'           => 'defaults',
#      'mountpath'         => "/${name}",
#      'mountpath_require' => 'false'
#    }
#
class generic-tmpl::os::lvm (
  $logical_volumes,
  $physical_volumes,
  $ensure = present,
  $volume_group = 'vg0'
){

  validate_array($physical_volumes)
  validate_hash($logical_volumes)

  $keys = keys($logical_volumes)

  physical_volume {$physical_volumes:
    ensure => $ensure,
  }

  volume_group {$volume_group:
    ensure           => $ensure,
    physical_volumes => $physical_volumes,
    require          => Physical_volume[$physical_volumes],
  }

  generic-tmpl::os::lvm::partition {$keys:
    volume_group    => $volume_group,
    logical_volumes => $logical_volumes,
  }

}

