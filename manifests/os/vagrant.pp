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
      owner  => 'vagrant',
      group  => 'vagrant',
    }

    file { '/home/vagrant/.ssh/authorized_keys':
      ensure => present,
      owner  => 'vagrant',
      group  => 'vagrant',
      source => 'puppet:///modules/generic-tmpl/vagrant/vagrant_insecure_public_key',
    }

  }

}
