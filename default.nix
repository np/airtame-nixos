with import <nixpkgs> {};

callPackage ./airtame-application.nix {
  gconf             = pkgs.gnome.GConf;
# jsonrpc-c-airtame = callPackage ./jsonrpc-c-airtame.nix {};
# zlog-airtame      = callPackage ./zlog-airtame.nix {};
# enet-airtame      = callPackage ./enet-airtame.nix {};
}
