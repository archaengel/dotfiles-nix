{ config, pkgs, ... }:
with pkgs; {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
      sha256 = "23534d6cd29a6e0ebabe88eddc1991158c540f762bd4c6136428bfb1df4dfcf0";
    }))
    (self: super:
      let
        buildSymlinks = self.runCommand "build-symlinks" { } ''
          mkdir -p $out/bin
          ln -s /usr/bin/xcrun /usr/bin/xcodebuild /usr/bin/tiffutil /usr/bin/qlmanage $out/bin
        '';
      in {
        yabai-nightly = super.yabai.overrideAttrs (oldAttrs: {
          version = "master";

          src = self.fetchFromGitHub {
            repo = "yabai";
            owner = "koekeishiya";
            rev = "master";
            sha256 = "sha256-SwoXH6d0blE+S5i4n0Y9Q8AJuQAAaQs+CK3y1hAQoPU=";
          };

          buildInputs = oldAttrs.buildInputs ++ [ self.unixtools.xxd ];
          nativeBuildInputs = [ buildSymlinks ];
        });
      })
  ];
}
