class generic-tmpl::mw::rabbitmq::lens {
  include generic-tmpl::mw::erlang::lens

  generic-tmpl::mw::augeas::lens {'rabbitmq':
    require => Augeas::Lens['erlang'],
  }
}
