{ config, pkgs, ... }:
with pkgs; {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
      sha256 = "sha256:1pj8ps24888a5gcv5bpg632m7ha18s1vw66s6wcn68iy8ahc7161";
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
            sha256 = "sha256-kMPf+g+7nMZyu2bkazhjuaZJVUiEoJrgxmxXhL/jC8M=";
          };

          buildInputs = oldAttrs.buildInputs ++ [ self.unixtools.xxd ];
          nativeBuildInputs = [ buildSymlinks ];
        });
      })
  ];
}
