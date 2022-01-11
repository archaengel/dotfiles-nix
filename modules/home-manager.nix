{ config, nixkpkgs, pkgs, system, ... }:

let
  isDarwin = system: (builtins.elem system pkgs.lib.platforms.darwin);
  systemSpecificPkgs = with pkgs;
    if ! isDarwin system then [ lxterminal ] else [ ];
  systemSpecificProgs = if isDarwin system then {
    kitty = {
      enable = true;
      extraConfig = builtins.readFile ./dotfiles/kitty/.config/kitty/kitty.conf;
    };
  } else
    { };
  systemSpecificXdg = if ! isDarwin system then {
    configFile.lxterminal = {
      source = ./dotfiles/lxterminal/.config/lxterminal/lxterminal.conf;
    };
  } else
    { };
in {
  users.users.god = { home = "/Users/god"; };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.god = {
    programs = {
      home-manager.enable = true;
      tmux = {
        enable = true;
        extraConfig = builtins.readFile ./dotfiles/tmux/.tmux.conf;
      };
    } // systemSpecificProgs;

    home.packages = with pkgs; [ treefmt neovim-nightly ] ++ systemSpecificPkgs;

    xdg = {
      configFile.nvim = {
        source = ./dotfiles/nvim/.config/nvim;
        recursive = true;
      };
    } // systemSpecificXdg;

  };
}
