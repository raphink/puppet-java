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
class generic-tmpl::mw-puppet-client {

  include puppet::client::cron

  case $operatingsystem {
    /Debian|Ubuntu/: {

      apt::preferences {"facter":
        ensure   => present,
        pin      => "release o=Camptocamp, n=${lsbdistcodename}",
        priority => 1100,
      }

      # this means: give high priority to packages from our reprepro, with
      # codename squeeze/lenny (!= squeeze-backports for example)
      # Add a similar resource with higher priority to install, say packages
      # from squeeze-backports or whatever experimental or legacy package repo.
      apt::preferences {["puppet", "puppet-common"]:
        ensure   => present,
        pin      => "release o=Camptocamp, n=${lsbdistcodename}",
        priority => 1100,
      }
    }
  }

  if (versioncmp($::puppetversion, 2) > 0) {
    augeas { 'remove legacy puppetd section':
      lens    => 'Puppet.lns',
      incl    => '/etc/puppet/puppet.conf',
      changes => 'rm puppetd',
    }
  }
}
