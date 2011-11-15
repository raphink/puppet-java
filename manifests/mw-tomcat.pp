class generic-tmpl::mw-tomcat {

  # avoid partial configuration on untested-distribution
  if $lsbdistcodename !~ /^(lenny|squeeze)$/ {
    fail "${name} not tested on ${operatingsystem}/${lsbdistcodename}"
  }

  include java
  include java::dev
  include tomcat::administration
  
  case $lsbdistcodename {
    lenny: { 
      $tomcat_version = '6.0.26'
      include tomcat::source 
    }
    squeeze: {
      include tomcat
    }
  }
 
}
