class generic-tmpl::mw::logstash::shipper {

  include ::logstash
  include ::logstash::shipper

  augeas {'limit logstash-shipper memory':
    changes => 'set /files/etc/default/logstash-shipper/LS_JAVA_OPTS \'"-Xms256m -Xmx256m"\'',
    before  => Service['logstash-shipper'],
  }

  apt::preferences{'libpcre3':
    pin      => 'release c=sysadmin, o=Camptocamp',
    priority => '1001',
  }

}
