# Class: generic-tmpl::os::c2c_user_accounts
#
# This class creates user accounts for all c2c users who have an ssh key in
# SADB and removes accounts who have no key
class generic-tmpl::os::c2c_user_accounts ($groups = [], $keys_in_etc = false) {

  $c2c_users = split(inline_template("<%= open('${sadb}/user/internal/uid').readline.chomp -%>"), ',')

  generic-tmpl::os::c2c_user_accounts_helper {$c2c_users:
    key_in_etc => $keys_in_etc,
    groups => $groups,
  }

}
