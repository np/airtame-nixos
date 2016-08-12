{stdenv,enet,m4,autoconf,automake,libtool,pkgconfig,fetchgit}:

stdenv.lib.overrideDerivation enet (self: {
  name = "enet-airtame";
  src = fetchgit {
    url    = "https://github.com/airtame/enet.git";
    # latest commit from the development branch as of 2016-08-22
    rev    = "bf67c2a8b7438e4fe2c22165dcfe3786a6c28f41";
    sha256 = "0jkygvaimawlmqlplvzz6d7j8al93ff342lbmw9fclrn0gac5vl4";
  };
  buildInputs  = self.buildInputs ++ [ m4 autoconf automake libtool pkgconfig ];
  preConfigure = ''
    libtoolize
    autoreconf -vfi
  '';
})
