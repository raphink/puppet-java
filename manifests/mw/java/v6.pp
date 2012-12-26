class generic-tmpl::mw::java::v6 {

  case $::osfamily {
    Debian: {
      apt::sources_list {"oracle-java_${::lsbdistcodename}":
        content => "deb http://java:puiBekieP9@java.pkg.camptocamp.net/staging ${::lsbdistcodename} oracle-java\n",
        before  => Class['::java::v6'],
      }

      include ::java::v6
    }

    default: {
      fail "OS family not supported ${::osfamily}"
    }

  }

}
