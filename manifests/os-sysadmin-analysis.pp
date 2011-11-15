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
      package {[
        'sipcalc',
        'jwhois',
        ]:
        ensure => present,
      }
    }
  }
}
