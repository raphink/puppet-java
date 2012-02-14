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

  case $puppetversion {
    "0.25.5": {
      # Workaround for ssh_authorized_users tries to save to local filebucket as non-root user, see :
      # http://projects.puppetlabs.com/issues/4267
      file { "ssh_authorized_key parsed.rb with fix":
        path => $operatingsystem ? {
          /Debian|Ubuntu/        => "/usr/lib/ruby/1.8/puppet/provider/ssh_authorized_key/parsed.rb",
          /RedHat|CentOS|Fedora/ => "/usr/lib/ruby/site_ruby/1.8/puppet/provider/ssh_authorized_key/parsed.rb",
        },
        ensure  => present,
        mode    => 0644,
        owner   => root,
        group   => root,
        source  => "puppet:///modules/generic-tmpl/puppet-0.25.5/parse-with-workaround-line72.rb",
        require => Package["puppet"],
      }
    }
  }

}
