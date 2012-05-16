class generic-tmpl::backport::php52 {

  tag("backport")

  if ($lsbdistcodename == 'squeeze') {

    apt::sources_list {"debian-lenny":
      ensure  => present,
      source  => 'puppet:///modules/os/etc/apt/sources.list.d/sources.list-debian-lenny',
      content => 'deb http://archive.debian.org/debian/ lenny main contrib non-free
',
    }

    # From http://dev.e-taxonomy.eu/trac/wiki/DebianDowngradePHP
    apt::preferences {
      ['libapache2-mod-php5', 'libapache2-mod-php5filter']:
        pin      => 'version 5.2*',
        priority => '1001';

      'php5-suhosin':
        pin      => 'version 0.9.2*',
        priority => '1001';

      ['php5', 'php5-cgi', 'php5-cli', 'php5-common', 'php5-curl', 'php5-dbg', 'php5-dev', 'php5-enchant', 'php5-gd', 'php5-gmp']:
        pin      => 'version 5.2*',
        priority => '1001';

      ['php5-imagick', 'php5-imap', 'php5-interbase', 'php5-intl', 'php5-ldap', 'php5-mcrypt', 'php5-mhash', 'php5-mysql', 'php5-odbc', 'php5-pgsql']:
        pin      => 'version 5.2*',
        priority => '1001';

      ['php5-pspell', 'php5-recode', 'php5-snmp', 'php5-sqlite', 'php5-sybase', 'php5-tidy', 'php5-xmlrpc', 'php5-xsl', 'php-pear']:
        pin      => 'version 5.2*',
        priority => '1001';

      'php-benchmark':
        pin      => 'version 1.2.7*',
        priority => '1001';

      'php-compat':
        pin      => 'version 1.5.0*',
        priority => '1001';

      'php-http':
        pin      => 'version 1.4.0*',
        priority => '1001';

      'php-http-request':
        pin      => 'version 1.4.2*',
        priority => '1001';

      'php-net-socket':
        pin      => 'version 1.0.8*',
        priority => '1001';

      'php-net-url':
        pin      => 'version 1.0.15*',
        priority => '1001';

      'php5-xdebug':
        pin      => 'version 2.0.3*',
        priority => '1001';
    }
  }
}
