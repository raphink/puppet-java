#
# == Template: mw-puppet-client
#
# Cette classe permet d'installer d'une manière puppet, facter et augeas
# 
# Dépendances:
#  - Module camptocamp/puppet-puppet
#  - Module camptocamp/puppet-apt
#  - Class os-debian-repository du module camptocamp/puppet-generic-tmpl
#
# Todo:
#  - Intégrer également les distributions RedHat et Centos
#
class generic-tmpl::mw-puppet-client inherits puppet::client {

  $puppet_client_version = $operatingsystem ? {
    RedHat => "0.25.5-1.el${lsbmajdistrelease}",
    Debian => "0.25.5-1~c2c+1",
  }

  $facter_version = $operatingsystem ? {
    RedHat => "1.5.8-1.el${lsbmajdistrelease}",
    Debian => $lsbdistcodename ? {
      lenny => "1.5.7-1~c2c+3",
    }
  }

  $augeas_version = $operatingsystem ? {
    RedHat => $lsbmajdistrelease ? {
      5 => "0.7.2-2.el${lsbmajdistrelease}",
      4 => "0.7.2-1.el${lsbmajdistrelease}",
    },
    Debian => $lsbdistcodename ? {
      lenny => "0.7.2-1~bpo50+1",
    },
  }

  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        /lenny|squeeze/: {

          if ($facter_version) {
            apt::preferences {"facter":
              ensure   => present, 
              pin      => "version ${facter_version}", 
              priority => 1100;
            }
            Package["facter"] {
              require +> Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sysadmin"],
            }
          }

          if ($augeas_version) {
            apt::preferences {["augeas-lenses","augeas-tools", "libaugeas0"]:
              ensure   => present,
              pin      => "version ${augeas_version}",
              priority => 1100;
            }
            Package["augeas-lenses","augeas-tools", "libaugeas0"] {
              require +> Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sysadmin"],
            }
          }

          apt::preferences {["puppet", "puppet-common","vim-puppet", "puppet-el"]:
            ensure   => present,
            pin      => "version ${puppet_client_version}",
            priority => 1100;
          }
          package {["puppet-common","vim-puppet", "puppet-el"]:
            ensure  => $puppet_client_version,
            require => Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sysadmin"],
            tag     => "install-puppet",
          }
          
          Package["puppet"] {
            require +> Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sysadmin"],
          }
     
        }
      }
    }
  } 
}
