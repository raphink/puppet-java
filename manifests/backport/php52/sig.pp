class generic-tmpl::backport::php52::sig inherits generic-tmpl::backport::php52 {

  if ($lsbdistcodename == 'squeeze') {
    apt::sources_list {"c2c-lenny-${repository}-sig":
      ensure  => present,
      content => "deb http://pkg.camptocamp.net/${repository} lenny sig sig-non-free",
      require => Apt::Key["5C662D02"],
    }

    # Downgrade to lenny version
    apt::preferences {'php5-mapscript-lenny':
      package  => 'php5-mapscript',
      pin      => 'version 5.0.3*',
      priority => '1100',
    }
  }
}
