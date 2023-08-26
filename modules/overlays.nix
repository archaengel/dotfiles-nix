{ config, pkgs, ... }:
with pkgs; {
  nixpkgs.overlays = [
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
            sha256 = "sha256-y4keN2C1DtXHRegAD6ROJHBXCG7fKih3AO7zg8N8FcE=";
          };

          buildInputs = oldAttrs.buildInputs ++ [ self.unixtools.xxd ];
          nativeBuildInputs = [ installShellFiles buildSymlinks ];
        });
      })
  ];
}
