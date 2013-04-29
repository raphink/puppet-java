class generic-tmpl::os::sysadmin::analysis {
  package {[
    'dstat',
    'ethtool',
    'file',
    'htop',
    'lsof',
    'ngrep',
    'nmap',
    'psmisc',
    'smartmontools',
    'strace',
    'sysstat',
    'tcpdump',
    'telnet',
    'tiobench',
    'traceroute',
    ]:
    ensure => present,
  }

  case $::osfamily {
    Debian: {
      package {[
        'atop',
        'dnsutils',
        'iotop',
        'ipcalc',
        'iptraf',
        'mtr-tiny',
        'netcat',
        'procinfo',
        'tshark',
        'whois',
        ]:
        ensure => present,
      }
      augeas {'enable sysstat':
        lens    => 'Shellvars.lns',
        incl    => '/etc/default/sysstat',
        changes => 'set ENABLED true',
        require => Package['sysstat'],
      }
    }
    RedHat: {
      if $::lsbmajdistrelease > 4 {
        # common packages for rhel5,6,…
        package {[
          'bind-utils',
          'iotop',
          'jwhois',
          'mtr',
          'nc',
          'wireshark',
        ]:
          ensure => present,
        }

        if $::lsbmajdistrelease == 5 {
          package {[
          'atop',
          'iptraf',
          'procinfo',
          'sipcalc',
          ]:
            ensure => present,
          }
        }

        # this one seems to be only on rhel5
        if $::lsbmajdistrelease == 6 {
          package {[
          'iptraf-ng',
          ]:
            ensure => present,
          }
        }
      }
    }
    default: {
      # notice, warn and err are useless
      # and a fail will be just as useless,
      # overkill and noisy for nothing.
      # But as "default" is mandatory, we
      # have to write it down, as an empty case.
      # And as some people say I don't write enough
      # comments, here's one we won't miss in the
      # code ;).
    }
  }
}
