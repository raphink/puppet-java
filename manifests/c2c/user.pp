# == Define: generic-tmpl::c2c::user
#
# Creates a new system user or add an ssh key to an existing user based on
# Camptocamp's data source (currently SADB).
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
#   *namevar*: Name of the system user to create or whose ssh key should be
#   installed on another account. If the 'onuser' parameter is not set or is
#   equal to 'username', and the account isn't already defined, this defines
#   it.
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
# === Examples
#
# Create a nominative system account with the user's ssh key:
#
# generic-tmpl::c2c::user {'ckaenzig':
#   ensure => present,
#   groups => ['sysadmin'],
# }
#
# Add a user's key in a shared system account:
#
# generic-tmpl::c2c::user {'ochriste':
#   ensure => present,
#   onuser => 'admin':
# }
#
define generic-tmpl::c2c::user (
  $ensure   = present,
  $username = false,
  $groups   = false,
  $onuser   = false,
  $target   = false
) {

  # If ssh key type is 'none', the user is removed
  $_ensure = $type ? {
    'none'  => false,
    default => $ensure,
  }

  $_username = $username ? {
    false   => $name,
    default => $username,
  }

  $_onuser = $onuser ? {
    false   => $_username,
    default => $onuser,
  }

  $email = url_get("${sadb}/user/${_username}/email")
  $type  = url_get("${sadb}/user/${_username}/ssh_pub_key_type")
  $key   = url_get("${sadb}/user/${_username}/ssh_pub_key")


  if ($_onuser == $_username) and (!defined(User[$_username])) {

    $firstname = url_get("${sadb}/user/${_username}/firstname")
    $lastname  = url_get("${sadb}/user/${_username}/lastname")
    $uid       = url_get("${sadb}/user/${_username}/uid_number")
  
    group {$_username:
      ensure => $ensure,
      gid    => $uid,
    }

    user {$_username:
      ensure     => $_ensure,
      comment    => "${firstname} ${lastname}",
      uid        => $uid,
      gid        => $uid,
      managehome => true,
      shell      => "/bin/bash",
      groups     => $groups,
      require    => [ Group[$_username], Class["c2c::skel"] ],
    }
  }

  ssh_authorized_key{"${email}-on-${_onuser}":
    ensure => $_ensure,
    target => $target? {false => undef, default => $target },
    user   => $target? {false => $_onuser, default => undef },
    type   => $type,
    key    => $key,
  }

}
