{
  config,
  nixkpkgs,
  pkgs,
  inputs,
  system,
  ...
}:

let
  isAarch = system: (builtins.elem system pkgs.lib.platforms.aarch64);

  # Raspberry Pi 4 isn't openGL3 compliant, which is necessary for kitty
  systemSpecificPkgs =
    with pkgs;
    if isAarch system then
      [ lxterminal ]
    else
      [
        arduino-cli
        unison-ucm
      ];

  systemSpecificXdg =
    if isAarch system then
      {
        configFile.lxterminal = {
          source = ./dotfiles/lxterminal/.config/lxterminal/lxterminal.conf;
        };
      }
    else
      { };
in
{
  imports = [
    ./home/jujutsu.nix
  ];

  users.users.god = {
    home = "/Users/god";
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.god = {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      home-manager.enable = true;
      tmux = {
        enable = true;
        extraConfig = builtins.readFile ./dotfiles/tmux/.tmux.conf;
      };
    };

    home = {
      packages =
        with pkgs;
        [
          ccls
          cmake
          delta
          emacs
          inputs.dotfiles.packages.${pkgs.system}.nvim
          treefmt
          zig
          zls
        ]
        ++ systemSpecificPkgs;
      stateVersion = "21.11";
    };

    xdg = systemSpecificXdg;

  };
}
