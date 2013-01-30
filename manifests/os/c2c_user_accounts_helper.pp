# Define: generic-tmpl::os::c2c_user_accounts_helper
#
# This definition creates one user account for a c2c user. It is mainly meant
# to be used by c2c_user_accounts.
define generic-tmpl::os::c2c_user_accounts_helper ($groups, $key_in_etc) {

  case $key_in_etc {
    "true", true: {
      $target = "/etc/ssh/authorized_keys/${name}"
    }
    "false", false: { 
      $target = false
    }
  }

  generic-tmpl::os::user {$name:
    ensure => present,
    groups => $groups,
    target => $target,
  }

}
