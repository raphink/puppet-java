class generic-tmpl::mw::logstash::shipper {

  include ::logstash
  include ::logstash::shipper

  apt::preferences{'libpcre3':
    pin      => 'release c=sysadmin, o=Camptocamp',
    priority => '1001',
  }

}
