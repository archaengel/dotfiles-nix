{
  config,
  nixkpkgs,
  pkgs,
  system,
  ...
}:

let
  isDarwin = system: (builtins.elem system pkgs.lib.platforms.darwin);
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

  systemSpecificProgs =
    if !isAarch system then
      {
        kitty = {
          enable = true;
          extraConfig = builtins.readFile ./dotfiles/kitty/.config/kitty/kitty.conf;
        };
      }
    else
      { };

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
    } // systemSpecificProgs;

    home = {
      packages =
        with pkgs;
        [
          treefmt
          rkdeveloptool
          cmake
          ccls
          emacs
          zig
          zls
        ]
        ++ systemSpecificPkgs;
      stateVersion = "21.11";
    };

    xdg = {
      # configFile.nvim = {
      #   source = ./dotfiles/nvim/.config/nvim;
      #   recursive = true;
      # };
    } // systemSpecificXdg;

  };
}
