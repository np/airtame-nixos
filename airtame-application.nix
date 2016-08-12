{
stdenv, fetchurl, buildEnv, makeWrapper

,zlib
,glib
,alsaLib
,dbus
,gtk
,pango
,freetype
,fontconfig
,cairo
,expat
,gconf
,gdk_pixbuf
,nspr
,nss
,libuuid

# From atom
, makeDesktopItem
, atk, libgnome_keyring3
, cups, libgpgerror, xorg, libcap, systemd

# Not sure if they are all needed
,libnotify
,libpulseaudio
,udev
,cmocka
,x264

# Libraries which were shipped with AIRTAME, thus these dependencies could be
# removed if necessary.
,curl
,libopus
,libtool

#,ffmpeg-full <= we need an earlier version

# Libraries patched by AIRTAME... seems to be not used anymore
#,jsonrpc-c-airtame
#,enet-airtame
#,zlog-airtame

# for debugging
#, bash
}:

with stdenv;

let
  airtameEnv = buildEnv {
    name = "env-airtame";
    paths = [
      cc.cc.lib zlib glib dbus.lib gtk atk pango.out freetype libgnome_keyring3
      fontconfig.lib gdk_pixbuf cairo.out cups expat libgpgerror alsaLib nspr gconf nss
      xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
      xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
      xorg.libXcursor libcap systemd
      libuuid

      curl cmocka libopus libtool x264.lib

      libnotify
      libpulseaudio
      libuuid
      udev

      # enet-airtame jsonrpc-c-airtame zlog-airtame
    ];
  };
in mkDerivation rec {
  name = "airtame-application-${version}";
  channel = "ga";
  version = "2.0.3";

  src = fetchurl {
    url = "https://downloads.airtame.com/application/${channel}/lin_x64/releases/deb/airtame-application_${version}_amd64.deb";
    sha256 = "11jm3lyr4l47iiw134pxji0vnds0ybn0lasm4ddzh70cfqn0a88d";
    name = "${name}.deb";
  };

  phases = [ "installPhase" "fixupPhase" ];

  buildInputs = [ airtameEnv makeWrapper ];

  airtame_core =
    "$out/airtame-application/resources/app.asar.unpacked/node_modules/airtame-streamer/vendor/airtame-core/lib";
  ld_lib_path_ext =
    "${airtame_core}:${airtameEnv}/lib:${airtameEnv}/lib64";
  airtame_modules =
    "${airtame_core}/airtame-modules";

  dontStrip = true;
  dontBuild = true;
  dontPatchELF = true;
  dontPatchShebangs = true;

  installPhase = ''
    mkdir -p $out
    ar p $src data.tar.xz | tar -C $out -xJ ./usr ./opt
    substituteInPlace $out/usr/share/applications/airtame-application.desktop \
      --replace /opt/airtame-application/launch-airtame.sh $out/bin/launch-airtame \
      --replace /opt/airtame-application/icon.png $out/airtame-application/icon.png
    mv $out/usr/* $out/opt/* $out/
    rm -r $out/usr/ $out/opt/
    mv $out/airtame-application/launch-airtame.sh{,.orig}
    rm ${airtame_core}/lib{curl,ltdl,cmocka,opus,x264}*
    # TODO from mplayer... libavcodec.so libavdevice.so libavfilter.so libavformat.so libavutil.so libswresample.so libswscale.so
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/airtame-application/airtame-application

    # Re-create launch-airtame as a wrapper around airtame-application
    makeWrapper $out/airtame-application/airtame-application $out/bin/launch-airtame \
      --set AIRTAME_MODULES "${airtame_modules}" \
      --prefix "LD_LIBRARY_PATH" : "${ld_lib_path_ext}" \
      --run "cd $out" \
      --add-flags --disable-gpu \
      --add-flags --enable-transparent-visuals
    # TODO add this cleanup line at the end of the script:
    # pkill -9 airtame-streamer airtame-application
  '';

  meta = with lib; {
    description = "Stream your display to an airtame dongle.";
    homepage = https://www.airtame.com/;
    maintainers = [ maintainers.np ];
    platforms = [ "x86_64-linux" ];
  };
}
