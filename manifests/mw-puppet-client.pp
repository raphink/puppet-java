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
class generic-tmpl::mw-puppet-client inherits puppet::client::cron {

  case $operatingsystem {
    Debian: {

      apt::preferences {"facter":
        ensure   => present,
        pin      => "release o=Camptocamp",
        priority => 1100,
      }

      apt::preferences {["puppet", "puppet-common"]:
        ensure   => present,
        pin      => "release o=Camptocamp",
        priority => 1100,
      }

    }
  }
}
