define generic-tmpl::mw::cowbuilder (
  $ensure='present',
  $dist=''
) {

  $real_dist = $dist ? {
    ''      => $name,
    default => $dist,
  }

  $pbuilderrc = $real_dist ? {
    /lenny/ => 'MIRRORSITE="http://archive.debian.org/debian"
',
    default => '',
  }

  pbuilder::cowbuilder {
    "${name}-i386":
      dist       => $real_dist,
      arch       => 'i386',
      pbuilderrc => $pbuilderrc;

    "${name}-amd64":
      dist       => $real_dist,
      arch       => 'amd64',
      pbuilderrc => $pbuilderrc;
  }

  # Add standard c2c sources.list
  pbuilder::apt::sources_list {
    "c2c-${real_dist}-staging-sysadmin on ${name}-i386":
      pbuilder_name => "${name}-i386",
      pbuilder_type => 'cowbuilder',
      filename      => "c2c-${real_dist}-staging-sysadmin",
      content       => 'deb http://pkg.camptocamp.net/staging ${real_dist} sysadmin
';

    "c2c-${real_dist}-staging-sysadmin on ${name}-amd64":
      pbuilder_name => "${name}-amd64",
      pbuilder_type => 'cowbuilder',
      filename      => "c2c-${real_dist}-staging-sysadmin",
      content       => 'deb http://pkg.camptocamp.net/staging ${real_dist} sysadmin
';
  }
}
