{ pkgs }:

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "borders";
  version = "main";
  src = pkgs.fetchFromGitHub {
    repo = "JankyBorders";
    owner = "FelixKratz";
    rev = "main";
    sha256 = "sha256-mpaEeoxYkrk4PjjVbRd9h7syQaxVTdja/vFGkZMbq+8=";
  };

  buildInputs = with pkgs.darwin.apple_sdk.frameworks; [
    CoreGraphics
    ApplicationServices
    AppKit
    pkgs.darwin.apple_sdk_11_0.frameworks.SkyLight
  ];

  patches = [ ../patches/borders.patch ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/borders $out/bin
  '';

  meta = {
    description = "Borders around active windows";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
})
