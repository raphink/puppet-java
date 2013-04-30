# == Class: java
#
class java (
  $vendor = 'openjdk',
  $version = '6',
  $package = undef,
) inherits ::java::params {

  class { '::java::packages': }
}
