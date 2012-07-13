class generic-tmpl::mw::sencha {
  apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sencha":
    ensure  => present,
    content => "deb http://sencha:eev1yoL4Ta@sencha.pkg.camptocamp.net/${repository} ${lsbdistcodename} sencha\n",
  }

  package {'sencha-sdk-tools':
    ensure  => present,
    require => Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sencha"],
  }

  apt::preferences {'sencha':
    package  => 'sencha-sdk-tools',
    pin      => "release o=Camptocamp",
    priority => 1100,
  }
}
