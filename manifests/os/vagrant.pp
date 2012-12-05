class generic-tmpl::os::vagrant {

  if str2bool($::vagrantbox) {

    user {'vagrant':
      ensure => present,
    }

    sudo::directive {'vagrant':
      ensure  => present,
      content => 'vagrant ALL=(ALL) ALL',
    }

  }

}
