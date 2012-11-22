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

  case $operatingsystem {
    Debian,Ubuntu: {
      package {[
        'ipcalc',
        'tshark',
        'whois',
        ]:
        ensure => present,
      }
    }
    CentOS,RedHat: {
      package { $lsbmajdistrelease ? {
          '5' => ['sipcalc', 'jwhois'],
          '6' => ['jwhois'],
        }:
        ensure => present,
      }
    }
  }
}
