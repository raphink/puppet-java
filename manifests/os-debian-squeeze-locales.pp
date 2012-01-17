class os-debian-squeeze-locales {

  include locales::sources

  locales::locale {
    "de_DE.ISO-8859-1": charset => "ISO-8859-1";
    "de_DE.UTF-8":      charset => "UTF-8";
    "en_GB.ISO-8859-1": charset => "ISO-8859-1";
    "en_GB.UTF-8":      charset => "UTF-8";
    "en_US.ISO-8859-1": charset => "ISO-8859-1";
    "en_US.UTF-8":      charset => "UTF-8";
    "fr_CH.ISO-8859-1": charset => "ISO-8859-1";
    "fr_CH.UTF-8":      charset => "UTF-8";
    "fr_FR.ISO-8859-1": charset => "ISO-8859-1";
    "fr_FR.UTF-8":      charset => "UTF-8";
    "it_IT.ISO-8859-1": charset => "ISO-8859-1";
    "it_IT.UTF-8":      charset => "UTF-8";
  }

  locales::alias {
    "de": locale => "de_DE.ISO-8859-1";
    "en": locale => "en_US.ISO-8859-1";
    "fr": locale => "fr_FR.ISO-8859-1";
    "it": locale => "it_IT.ISO-8859-1";
  }

}
