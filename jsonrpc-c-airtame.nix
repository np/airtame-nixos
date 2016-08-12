{ stdenv, fetchgit, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  rev = "e06e60b28da6c6f9cb6dc04923ce2011abcf474a";

  name = "jsonrpc-c-${rev}";

  src = fetchgit {
    url = "https://github.com/airtame/jsonrpc-c";
    rev = rev;
    sha256 = "11kaa19jcpmp87rsmd8yg5nc3mh5hiwc7dx2bb42b1avk7hxbvpm";
  };

  buildInputs = [ autoconf automake libtool ];

  preConfigure = "autoreconf -i";

  meta = with stdenv.lib; {
    description= "JSON-RPC in C (server only for now)";
    homepage = "https://github.com/airtame/jsonrpc-c";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.np ];
  };
}
