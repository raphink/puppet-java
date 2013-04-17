class generic-tmpl::os-sysadmin-analysis {
  package {[
    'dstat',
    'file',
    'htop',
    'iptraf',
    'lsof',
    'ngrep',
    'nmap',
    'psmisc',
    'smartmontools',
    'strace',
    'sysstat',
    'tiobench',
    'tcpdump',
    ]:
    ensure => present,
  }

  case $::osfamily {
    Debian: {
      package {[
        'dnsutils',
        'iotop',
        'ipcalc',
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
        ]:
          ensure => present,
        }
        # this one seems to be only on rhel5
        if $::lsbmajdistrelease == 5 {
          package {['sipcalc']:
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
