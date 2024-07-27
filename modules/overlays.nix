{ config, pkgs, ... }:
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
            rev = "9fffe016ea91d221cb60891f1bb9b39fae738808";
            sha256 = "sha256-G7yjxhKk5Yz6qLHy8I8MMmZdVYUggGVvIW0j5kdkwlo=";
          };

          buildInputs = oldAttrs.buildInputs ++ [ final.unixtools.xxd ];
          nativeBuildInputs = [ installShellFiles buildSymlinks ];
        });

        sketchybar-nightly = prev.sketchybar.overrideAttrs (oldAttrs: {
          version = "master";
          src = final.fetchFromGitHub {
            repo = "SketchyBar";
            owner = "FelixKratz";
            rev = "1fbf8559302f4e69e015f08a76e05ea84a93cef8";
            sha256 = "sha256-6MqTyCqFv5suQgQ5a9t1mDA2njjFFgk67Kp7xO5OXoA=";
          };
        });

        liblpeg = import ./packages/liblpeg-darwin.nix { inherit pkgs; };

        borders = import ./packages/borders.nix { inherit pkgs; };
      })
  ];
}
