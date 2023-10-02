{ config, inputs, nixpkgs, pkgs, stable, ... }:

{
  imports = [./overlays.nix];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = with pkgs; [
      bat
      boost
      buildpack
      cairo
      curl
      gh
      git
      irssi
      jq
      kitty
      luajitPackages.luarocks
      minikube
      neovim-nightly
      nixfmt
      qemu
      qmk
      stow
      gdb
      haskellPackages.cabal-install
      terraform
      terraform-ls
      ihp-new
      tmux
      tree
      vim
      wget
      zlib
    ];

    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${nixpkgs}";
      stable.source = "${stable}";
    };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixPath = (builtins.map (source: {
      "${source}" = "/etc/${config.environment.etc.${source}.target}";
    }) [ "home-manager" "nixpkgs" "stable" ])
      ++ [{ darwin-config = "$HOME/.nixpkgs/modules/darwin.nix"; }];
  };

  programs.nix-index.enable = true;

  services.yabai.enable = true;
  services.yabai.enableScriptingAddition = true;
  services.yabai.package = pkgs.yabai-nightly;
  services.yabai.config = {
    window_border = "on";
    window_border_width = 6;
    active_window_border_color = "0xf7768eff";
    top_padding = 6;
    bottom_padding = 6;
    right_padding = 6;
    left_padding = 6;
    window_gap = 6;
  };
  services.yabai.extraConfig = ''
    yabia -m space --layout bsp
    yabai -m signal --add event=window_destroyed \
      action="yabai -m window --focus last"
  '';

  services.skhd.enable = true;
  services.skhd.skhdConfig = ''
    alt - j : yabai -m window --focus next &> /dev/null || yabai -m window --focus stack.next
    alt - k : yabai -m window --focus prev &> /dev/null || yabai -m window --focus stack.prev

    alt + shift - j : yabai -m window --swap west
    alt + shift - k : yabai -m window --swap east
    alt + shift + ctrl - j : yabai -m window --space next
    alt + shift + ctrl - k : yabai -m window --space prev
    alt + shift - u : yabai -m display --focus next
    alt + shift - d : yabai -m display --focus prev

    alt + shift - return : kitty --single-instance --working-directory /Users/god
    alt - space : yabai -m space --layout `yabai -m query --spaces | jq -r 'map(select(."has-focus")) | .[0].type as $current | {layouts: ["bsp", "stack", "float"]} | { layouts: .layouts, next: (.layouts | (index($current) + 1) % 3)} | nth(.next; .layouts[])'`
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-substituters = [
      "https://cache.nixos.org/"
      "https://cache.iog.io"
  ];
  nix.settings.trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
}
