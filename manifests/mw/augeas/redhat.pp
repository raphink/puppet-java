class generic-tmpl::mw::augeas::redhat {

  include ::augeas::redhat

  if $operatingsystem =~ /RedHat|CentOS/ and $lsbmajdistrelease == '6' {
    # nrpe.aug has bugs in 0.9.0, so we backport it from 0.10.0
    # (and remove the original one so that augeas uses ours)
    augeas::lens{'nrpe':
      ensure      => present,
      lens_source => 'puppet:///modules/generic-tmpl/augeas/nrpe.aug-0.10.0',
      test_source => 'puppet:///modules/generic-tmpl/augeas/test_nrpe.aug-0.10.0',
      require     => file ['/usr/share/augeas/lenses/dist/nrpe.aug'],
    }
    file {'/usr/share/augeas/lenses/dist/nrpe.aug':
      ensure => absent,
    }
  }
}
