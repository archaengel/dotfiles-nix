{ config, pkgs, neovim, ... }:
with pkgs; {
  nixpkgs.overlays = [
    (final: prev:
      let
        buildSymlinks = final.runCommand "build-symlinks" { } ''
          mkdir -p $out/bin
          ln -s /usr/bin/xcrun /usr/bin/xcodebuild /usr/bin/tiffutil /usr/bin/qlmanage $out/bin
        '';
      in {
        yabai-nightly = prev.yabai.overrideAttrs (oldAttrs: {
          version = "master";

          src = final.fetchFromGitHub {
            repo = "yabai";
            owner = "koekeishiya";
            rev = "master";
            sha256 = "sha256-G7yjxhKk5Yz6qLHy8I8MMmZdVYUggGVvIW0j5kdkwlo=";
          };

          buildInputs = oldAttrs.buildInputs ++ [ final.unixtools.xxd ];
          nativeBuildInputs = [ installShellFiles buildSymlinks ];
        });

        neovim-nightly = neovim.overrideAttrs (oldAttrs: {
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ final.liblpeg ];
        });

        sketchybar-nightly = prev.sketchybar.overrideAttrs (oldAttrs: {
          version = "master";
          src = final.fetchFromGitHub {
            repo = "SketchyBar";
            owner = "FelixKratz";
            rev = "master";
            sha256 = "sha256-6MqTyCqFv5suQgQ5a9t1mDA2njjFFgk67Kp7xO5OXoA=";
          };
        });

        liblpeg = import ./packages/liblpeg-darwin.nix { inherit pkgs; };

        borders = import ./packages/borders.nix { inherit pkgs; };
      })
  ];
}
