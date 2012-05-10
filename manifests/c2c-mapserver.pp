class generic-tmpl::c2c-mapserver inherits mapserver::debian {

  include generic-tmpl::os::pkgrepo::sig

  case $lsbdistcodename {
    squeeze: {
      apt::preferences{[
        "gdal-bin",
        "libgdal-doc",
        "libgdal-perl",
        "libgdal-ruby",
        "libgdal-ruby1.8",
        "libgdal1-1.8.0",
        "libgdal1-dev",
        "python-gdal"]:
        pin      => "version 1.8.0-1~c2c+*",
        priority => 1001,
      }

      # Package qgis-mapserver already has
      # an apt::preferences settting
      # with priority 1100 in qgis::repo
      apt::preferences{"qgis-c2c":
        package  => 'qgis-mapserver qgis-providers qgis-providers-common',
        pin      => 'release c=sig',
        priority => 1200,
      }

      apt::preferences{'mapserver':
        package  => 'cgi-mapserver libmapscript-ruby libmapscript-ruby1.8 libmapscript-ruby1.9.1 mapserver-bin mapserver-doc perl-mapscript php5-mapscript python-mapscript',
        pin => 'version 6.0.0-1~c2c*',
        priority => 1001,
      }

      apt::preferences{'libecw':
        pin => 'version 3.3-1+squeeze1~c2c*',
        priority => 1001,
      }

      package {'nodejs':
        ensure => present,
      }

      package {'libgdal1-1.7.0':
        ensure => purged,
      }
    }

    lenny: {

       apt::preferences{"sig":
         package  => "*",
         pin      => "release c=sig, o=Camptocamp",
         priority => 1001,
       }

       apt::preferences{"sig-non-free":
         package  => "*",
         pin      => "release c=sig-non-free, o=Camptocamp",
         priority => 1001,
       }

       apt::preferences{["libgeos-c1", "libgeos-dev", "proj"]:
         pin      => "release a=lenny-backports, o=Camptocamp",
         priority => 1001,
       }

       case $mapserver_version {
         default: { fail "Unsupported value for \$mapserver_version. Choices are 5.4 or 5.6." }
         "","5.4": { }
         "5.6": {
           apt::sources_list {"c2c-${lsbdistcodename}-${repository}-mapserver-5.6":
             ensure  => present,
             content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} mapserver-5.6\n",
             require => Apt::Key["5C662D02"],
           }
           apt::preferences{"mapserver-5_6":
             package  => "*",
             pin      => "release c=mapserver-5.6",
             priority => 1001,
           }
        }
      }
    }
  }
}
