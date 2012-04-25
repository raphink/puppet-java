# petit helper permettant d'installer un paquet, seulement si il n'est pas
# défini ailleurs, les noms différents entre debian et redhat et finalement
# ne pas l'installer si il n'est pas disponible.
define generic-tmpl::package::condinstall ($ensure=present,
  $centos='',
  $lenny='',
  $squeeze='',
  $redhat='') {

  case $::operatingsystem {
    Debian: {
      $pkg = $::lsbdistcodename ? {
        lenny    => $lenny    ? { '' => $name, default => $lenny,},
        squeeze  => $squeeze  ? { '' => $name, default => $squeeze,},
        default  => $name,
      }
    }
    CentOS: {
      $pkg = $centos ? { '' => $name, default => $centos, }
    }
    RedHat: {
      $pkg = $redhat ? { '' => $name, default => $redhat, }
    }
    default: { $pkg = $name }
  }

  if ( $pkg != 'unavailable' and !defined(Package[$pkg]) ) {
    package { $pkg:
      ensure => present,
    }
  }
}

