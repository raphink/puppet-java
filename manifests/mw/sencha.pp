class generic-tmpl::mw::sencha {
  apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sencha":
    ensure  => present,
    content => "deb http://sencha:eev1yoL4Ta@pkg.camptocamp.net/${repository} ${lsbdistcodename} sencha\n",
  }

  package {'sencha-sdk-tools':
    ensure  => present,
    require => Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-sencha"],
  }
}
