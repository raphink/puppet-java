class generic-tmpl::mw-tomcat {

  # avoid partial configuration on untested-redhat-release
  if $lsbdistcodename !~ /^(squeeze|squeeze)$/ {
    fail "class ${name} not tested on ${operatingsystem}/${lsbdistcodename}"
  }  

  case $lsbdistcodename {
    "lenny": {
      $tomcat_version = '6.0.26'
      include java::v6
      include tomcat::v6
    }
    "squeeze": {
      include java
      include tomcat
    }
  }

  include tomcat::administration
  include java::dev
 
}
