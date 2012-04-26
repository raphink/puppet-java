class generic-tmpl::mw::augeas::debian inherits ::augeas::debian {

  if ($augeas_version != "present") {
    apt::preferences {'augeas':
      package  => 'augeas-lenses augeas-tools libaugeas0',
      ensure   => present,
      pin      => "version ${augeas_version}",
      priority => 1100;
    }

    apt::preferences {'libaugeas-ruby1.8':
      ensure   => present,
      pin      => "version ${augeas_ruby_version}",
      priority => 1100,
    }

    Package["augeas-lenses","augeas-tools", "libaugeas0"] {
      require +> Apt::Sources_list["c2c-${lsbdistcodename}-${repository}-backports"],
    }
  }
}
