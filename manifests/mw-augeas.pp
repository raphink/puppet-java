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
      lenny    => "0.10.0-0ubuntu4~c2c~lenny2",
      squeeze  => "0.10.0-0ubuntu4~c2c~squeeze1",
      default  => "present",
    },
  }

  case $operatingsystem {
    /Debian|Ubuntu/: {
      include generic-tmpl::my-augeas
    }
    /RedHat|CentOS/: {
      include augeas::redhat
    }
  } 
}
