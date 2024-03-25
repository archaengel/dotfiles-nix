{ config, inputs, nixpkgs, pkgs, stable, ... }:

let
  gdk = pkgs.google-cloud-sdk.withExtraComponents
    (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);
in {
  imports = [ ./overlays.nix ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = with pkgs; [
      bat
      boost
      buildpack
      cairo
      curl
      elan
      gh
      git
      delta
      irssi
      jq
      gdk
      kitty
      luajitPackages.luarocks
      minikube
      neovim-nightly
      nixfmt
      fd
      ripgrep
      qemu
      qmk
      stow
      openscad
      unison-ucm
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
      borders
      watch
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
    top_padding = 6;
    bottom_padding = 6;
    right_padding = 6;
    left_padding = 6;
    window_gap = 6;
  };
  services.yabai.extraConfig = ''
    yabai -m config debug_output on
    yabai -m config external_bar all:30:0
    yabai -m space --layout bsp
    yabai -m signal --add event=window_destroyed \
      action="yabai -m window --focus last"

    borders active_color=0xf7768eff inactive_color=0x00000000 width=5.0 2>/dev/null 1>&2 &
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

    alt - 0x12 : yabai -m space --focus 1 2>/dev/null
    alt - 0x13 : yabai -m space --focus 2 2>/dev/null
    alt - 0x14 : yabai -m space --focus 3 2>/dev/null
    alt - 0x15 : yabai -m space --focus 4 2>/dev/null
    alt - 0x17 : yabai -m space --focus 5 2>/dev/null
    alt - 0x16 : yabai -m space --focus 6 2>/dev/null
    alt - 0x1A : yabai -m space --focus 7 2>/dev/null
    alt - 0x1C : yabai -m space --focus 8 2>/dev/null
    alt - 0x19 : yabai -m space --focus 9 2>/dev/null

    alt + shift - return : kitty --single-instance --working-directory /Users/god
    alt - space : yabai -m space --layout `yabai -m query --spaces | jq -r 'map(select(."has-focus")) | .[0].type as $current | {layouts: ["bsp", "stack", "float"]} | { layouts: .layouts, next: (.layouts | (index($current) + 1) % 3)} | nth(.next; .layouts[])'`
  '';

  services.sketchybar.enable = true;
  services.sketchybar.package = pkgs.sketchybar-nightly;
  services.sketchybar.config = ''
    sketchybar --bar height=24 \
      blur_radius=20 \
      position=top \
      y_offset=6 \
      padding_left=2 \
      padding_right=2 \
      corner_radius=10 \
      margin=6 \
      color=0x44000000 \
      shadow=on

    sketchybar --default icon.font="JetBrainsMono NF:Bold:14.0"

    spaces=$(seq 9)
    space_args=()

    for i in ''${spaces[@]}; do
        sid=$((i))
        space_args+=(
            --add space space.$sid left \
            --set space.$sid icon=$sid \
                  associated_space=$sid \
                  icon.padding_right=6 \
                  icon.highlight_color=0xff768eff \
                  click_script="yabai -m space --focus $sid"
        )
    done

    sketchybar "''${space_args[@]}"

    sketchybar --update
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-substituters = [
    "https://cache.nixos.org?priority=10"
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
}
