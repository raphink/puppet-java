# == Define: generic-tmpl::os::user
#
# Creates a new system user or add an ssh key to an existing user based on
# Camptocamp's data source.
#
# Currently, if the ssh key type is set to none, the user's account and/or its
# ssh key are removed.
#
# === Parameters
#
# [*ensure*]
#   'present' or 'absent'. Creates or removes the user / the key.
#
# [*username*]
#   *namevar*: Name of the system user to create or account in which to add
#   the ssh key. When creating a new user it is best not to set this and have
#   only the username in the namevar. When adding multiple keys in an account,
#   it is necessary to have distinct namevars and specify the target system
#   user using the 'username' parameter.
#
# [*groups*]
#   If the user has to be defined, it will be added to this groups.
#
# [*onuser*]
#   Optional. Set this to the existing system account on which you want to add
#   the ssh key. Only useful if it's different from 'username'.
#
# [*target*]
#   Optional. Target location for the ssh key. Defaults the the user's
#   ~/.ssh/authorized_keys file. See the ssh_authorized_key's documentation
#   for more information.
#
# [*backend*]
#   Optional. Backend user definition to use. Currently only SADB is supported.
#
# === Examples
#
# Create a nominative system account with the user's ssh key:
#
# generic-tmpl::os::user {'ckaenzig':
#   ensure => present,
#   groups => ['sysadmin'],
# }
#
# Add a user's key in a shared system account:
#
# generic-tmpl::os::user {'ochriste':
#   ensure => present,
#   onuser => 'admin':
# }
#
define generic-tmpl::os::user (
  $ensure   = present,
  $username = false,
  $groups   = false,
  $onuser   = false,
  $target   = false,
  $backend  = 'sadb'
) {

  case $backend {
    'sadb': {
      generic-tmpl::os::user::sadb {$name:
        ensure   => $ensure,
        username => $username,
        groups   => $groups,
        onuser   => $onuser,
        target   => $target,
      }
    }
    default: { fail 'Unknown backend for generic-tmpl::os::user' }
  }

}
