{ config, pkgs, ... }:
with pkgs;
{
  nixpkgs.overlays = [
    (
      final: prev:
      {
        sketchybar-nightly = prev.sketchybar.overrideAttrs (oldAttrs: {
          version = "2.22.1";
          src = final.fetchFromGitHub {
            repo = "SketchyBar";
            owner = "FelixKratz";
            rev = "a8691a3fca676557bc6d8c69167e61df7462bbfe";
            sha256 = "sha256-oJ5fzyub5CYp3Is06uPflH63+3KS8R1FjVmQVG3VFIw=";
          };
        });

        liblpeg = import ./packages/liblpeg-darwin.nix { inherit pkgs; };

        borders = import ./packages/borders.nix { inherit pkgs; };
      }
    )
  ];
}
