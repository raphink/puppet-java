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
      package { $::lsbmajdistrelease ? {
          '5' => ['sipcalc', 'jwhois'],
          '6' => ['jwhois'],
        }:
        ensure => present,
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
