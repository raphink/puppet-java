class java::packages {
  validate_string($java::vendor)
  validate_re($java::vendor, ['bea', 'ibm', 'sun', 'openjdk'])

  validate_string($java::version)

  case $java::vendor {
    'bea': {
      $package = "java-1.${java::version}.0-bea"
    }

    'ibm': {
      $package = "java-1.${java::version}.0-ibm"
    }

    'sun': {
      $package = $::operatingsystem ? {
        'RedHat'        => "java-1.${java::version}.0-sun",
        'CentOS'        => "jdk-1.${java::version}.0",
        /Debian|Ubuntu/ => "sun-java${java::version}-jdk",
      }
    }

    'openjdk': {
      $package = $::osfamily ? {
        'RedHat' => "java-1.${java::version}.0-openjdk",
        'Debian' => "openjdk-${java::version}-jdk",
      }
    }

    default: {
      fail "Unsupported vendor ${java::vendor}"
    }
  }
}
