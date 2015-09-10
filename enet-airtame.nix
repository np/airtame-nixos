{stdenv,enet,m4,autoconf,automake,libtool,pkgconfig,fetchgit}:

stdenv.lib.overrideDerivation enet (self: {
  name = "enet-airtame";
  src = fetchgit {
    url    = "https://github.com/airtame/enet.git";
    rev    = "546e52325a227e6f185bfebed7ca02cba5cd5946";
    sha256 = "de9c2d0a404e835ef89c065436a9a855385758e136a22fe4b4cb826ac019761e";
  };
  buildInputs  = self.buildInputs ++ [ m4 autoconf automake libtool pkgconfig ];
  preConfigure = ''
    libtoolize
    autoreconf -vfi
  '';
})
