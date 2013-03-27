class generic-tmpl::os::vagrant {

  if str2bool($::vagrantbox) {

    user {'vagrant':
      ensure => present,
    }

    sudo::directive {'vagrant':
      ensure  => present,
      content => 'vagrant ALL=(ALL) ALL',
    }

    file { '/home/vagrant/.ssh':
      ensure => directory,
    }

    file { '/home/vagrant/.ssh/authorized_keys':
      ensure => present,
      source => 'puppet:///modules/generic-tmpl/vagrant/vagrant_insecure_public_key',
    }

  }

}
