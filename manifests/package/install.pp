class generic-tmpl::package::install {
  include generic-tmpl::package::curl
  include generic-tmpl::package::cvs
  include generic-tmpl::package::dos2unix
  include generic-tmpl::package::elinks
  include generic-tmpl::package::emacs
  include generic-tmpl::package::gnupg
  include generic-tmpl::package::patch
  include generic-tmpl::package::pwgen
  include generic-tmpl::package::rsync
  include generic-tmpl::package::screen
  include generic-tmpl::package::sharutils
  include generic-tmpl::package::tmux
  include generic-tmpl::package::unix2dos
  include generic-tmpl::package::vim
  include generic-tmpl::package::wget
  include generic-tmpl::package::zip

  Package <| tag == 'common-packages' |>
}
