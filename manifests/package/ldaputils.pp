class generic-tmpl::package-ldaputils {
  case $::osfamilly {
    'Debian': { $pkg_name = 'ldap-utils' }
    'RedHat': { $pkg_name = 'openldap-clients' }
    default: { }
  }

  @package {'ldaputils':
    ensure => present,
    name   => $pkg_name,
    tag    => 'common-packages',
  }
}
