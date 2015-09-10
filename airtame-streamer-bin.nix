{stdenv,gcc,libuuid,glib,nss,nspr,gconf,fontconfig,freetype,pango,cairo,xlibs,libnotify,expat,dbus,alsaLib,gtk,gdk_pixbuf,udev,makeWrapper,zlog-airtame,enet-airtame}:
stdenv.mkDerivation rec {
  name = "airtame-streamer";
  src = ./AIRTAME-v1.0.2-13_x64;

  buildInputs = [ makeWrapper ];

  rpath = stdenv.lib.makeLibraryPath [
    stdenv.glibc

    glib
    gconf
    gcc.cc
    libuuid
    nss
    nspr
    fontconfig
    freetype
    pango
    cairo
    xlibs.libX11
    xlibs.libXi
    xlibs.libXcursor
    xlibs.libXext
    xlibs.libXfixes
    xlibs.libXrender
    xlibs.libXcomposite
    alsaLib
    xlibs.libXdamage
    xlibs.libXtst
    xlibs.libXrandr
    expat
    dbus
    gtk
    udev
    zlog-airtame
    enet-airtame
    gdk_pixbuf
    libnotify
  ] + ":${stdenv.cc.cc}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}"
    + ":$out/app/streamer/lib"
  ;

  dontStrip = true;
  dontBuild = true;
  dontPatchELF = true;
  dontPatchShebangs = true;
  prePatch = ''
    for file in nw/nw nw/nwjc app/streamer/bin/airtame-receiver app/streamer/bin/airtame-streamer; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
               "$file" || :
    done
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    cp -r app nw "$out"/
    rm "$out"/app/streamer/lib/lib{zlog,enet}*
    sed -ie "s|env.LD_LIBRARY_PATH = process.cwd() + '/streamer/lib';||" "$out"/app/node_modules/airtame.js
    makeWrapper $out/nw/nw $out/bin/launch-airtame \
      --set AIRTAME_MODULES $out/app/streamer/lib/airtame-modules \
      --set LD_LIBRARY_PATH "${rpath}" \
      --run "cd $out" \
      --add-flags app/ \
      --add-flags --enable-transparent-visuals \
      --add-flags --disable-gpu
  '';
}
