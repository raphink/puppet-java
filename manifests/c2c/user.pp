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
