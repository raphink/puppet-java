class java::params {

  $jai_imageio_version = $java_jai_imageio_version ? {
    ''      => '1_1',
    default => $java_jai_imageio_version,
  }

  $jai_imageio_url_base = $java_jai_imageio_url_base ? {
    ''      => 'http://download.java.net/media/jai-imageio/builds/release/1.1',
    default => $java_jai_imageio_url_base,
  }

  $jai_arch = $java_jai_arch ? {
    'i386'  => 'i586',
    default => 'amd64',
  }

  $jai_version = $java_jai_version ? {
    ''      => '1_1_3',
    default => $java_jai_version,
  }

  $jai_url_base = $java_jai_url_base ? {
    ''      => 'http://download.java.net/media/jai/builds/release',
    default => $java_jai_url_base,
  }

}
