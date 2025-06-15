{
  config,
  nixkpkgs,
  pkgs,
  inputs,
  username,
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
  users.users.god = {
    home = "/Users/god";
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.god =
    { username, ... }:
    {
      imports = [
        ./home/jujutsu.nix
      ];

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

      programs.zsh = {
        defaultKeymap = "viins";
        enable = true;
        syntaxHighlighting.enable = true;
        history = {
          ignoreDups = true;
          ignoreSpace = true;
          share = true;
        };
        initContent =
          let
            instantPrompt = pkgs.lib.mkOrder 500 ''
              if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
                source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
              fi
            '';
            importP10k = pkgs.lib.mkOrder 1000 "[[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}";
          in
          pkgs.lib.mkMerge [
            instantPrompt
            importP10k
          ];
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
      };

    };
}
