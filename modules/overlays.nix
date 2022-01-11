{ config, pkgs, ... }:
with pkgs; {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
      sha256 = "1l5qa7m4xxr9kxfp9dwcc9i2qf3ncbai6nb3bsz360flgbs90ahk";
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
