class generic-tmpl::os::vagrant {

  if str2bool($::vagrantbox) {
    sudo::directive {'vagrant':
      ensure  => present,
      content => 'vagrant ALL=(ALL) ALL',
    } 
  }

}
