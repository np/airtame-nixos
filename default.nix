with import <nixpkgs> {};

callPackage ./airtame-streamer-bin.nix {
  gconf        = pkgs.gnome.GConf;
  zlog-airtame = callPackage ./zlog-airtame.nix {};
  enet-airtame = callPackage ./enet-airtame.nix {};
}
