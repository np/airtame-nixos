{stdenv,zlog,fetchgit}:

stdenv.lib.overrideDerivation zlog (oldAttrs: {
  name = "zlog-airtame";
  src = fetchgit {
    url    = "https://github.com/airtame/zlog.git";
    rev    = "959f21b1b69134bc62318be773a4ed3166b827a5";
    sha256 = "0g942yh2c29s9nrjbg07sm62p46snn296x84pvxqr6gmccj4mzfh";
  }; })
