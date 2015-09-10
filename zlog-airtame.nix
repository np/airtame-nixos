{stdenv,zlog,fetchgit}:

stdenv.lib.overrideDerivation zlog (oldAttrs: {
  name = "zlog-airtame";
  src = fetchgit {
    url    = "https://github.com/airtame/zlog.git";
    rev    = "959f21b1b69134bc62318be773a4ed3166b827a5";
    sha256 = "76e3ef579fc0f7d48f18ea1073211a022c79a6b69bd5f444ca91ee81225cbc35";
  }; })
