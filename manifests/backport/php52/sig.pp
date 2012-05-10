class generic-tmpl::backport::php52::sig inherits generic-tmpl::backport::php52 {

  if ($lsbdistcodename == 'squeeze') {
    # Use specific mapserver version built for PHP 5.2 and Gdal 1.8
    apt::sources_list {"c2c-${lsbdistcodename}-${repository}-mapserver-php-5.2":
      ensure  => present,
      content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} mapserver-php-5.2",
      require => Apt::Key["5C662D02"],
    }

    apt::preferences {'mapserver-php52':
      package  => '*',
      pin      => 'release c=mapserver-php-5.2',
      priority => '1100',
    }
  }
}
