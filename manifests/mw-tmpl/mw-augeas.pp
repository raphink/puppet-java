#
# == Template: mw-augeas
#
# Cette classe permet d'installer augeas a la version voulue
# 
# Dépendances:
#  - Module camptocamp/puppet-augeas
#  - Class os-debian-repository du module camptocamp/puppet-generic-tmpl
#
class generic-tmpl::mw-augeas {

  $augeas_version = $operatingsystem ? {
    RedHat => $lsbmajdistrelease ? {
      5 => "0.7.2-2.el${lsbmajdistrelease}",
      4 => "0.7.2-1.el${lsbmajdistrelease}",
    },
    Debian => $lsbdistcodename ? {
      lenny   => "0.7.2-1~bpo50+1",
      default => "present",
    },
  }

  case $operatingsystem {
    /Debian|Ubuntu/: {
      class my-augeas inherits augeas::debian {
 
        if ($augeas_version != "present") {
          apt::preferences {["augeas-lenses","augeas-tools", "libaugeas0"]:
            ensure   => present,
            pin      => "version ${augeas_version}",
            priority => 1100;
          }
          Package["augeas-lenses","augeas-tools", "libaugeas0"] {
            require +> Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-backports"],
          }
        }
      }
      include my-augeas 
    }
    /RedHat|CentOS/: {
      include augeas::redhat
    }
  } 
}
