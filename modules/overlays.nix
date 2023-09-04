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
            sha256 = "sha256-3vrW7UPO5WtxUEdhc4VsVDrTNvztwXp1ekscOqJGIQ8=";
          };

          buildInputs = oldAttrs.buildInputs ++ [ final.unixtools.xxd ];
          nativeBuildInputs = [ installShellFiles buildSymlinks ];
        });

	neovim-nightly = neovim.overrideAttrs (oldAttrs: {
	  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [final.liblpeg];
	});

	liblpeg = import ./packages/liblpeg-darwin.nix { inherit pkgs; };
      })
  ];
}
