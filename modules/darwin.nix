{
  config,
  inputs,
  nixpkgs,
  pkgs,
  stable,
  ...
}:

let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]
  );
in
{
  imports = [
    ./overlays.nix
    ./skhd.nix
  ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = with pkgs; [
      bat
      boost
      borders
      btop
      buildpack
      cachix
      cairo
      curl
      delta
      elan
      fd
      gdb
      gdk
      gh
      git
      haskellPackages.cabal-install
      ihp-new
      irssi
      jq
      kitty
      lua51Packages.lua
      luajitPackages.luarocks
      minikube
      neovim
      nixd
      nixfmt-rfc-style
      openscad
      poetry
      py-spy
      python3
      python3Packages.jedi-language-server
      python3Packages.mypy
      qemu
      ripgrep
      rust-analyzer
      stow
      texliveMedium
      tmux
      tree
      vim
      watch
      wget
      yarn
      zathura
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
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixPath =
      (builtins.map (source: { "${source}" = "/etc/${config.environment.etc.${source}.target}"; }) [
        "home-manager"
        "nixpkgs"
        "stable"
      ])
      ++ [ { darwin-config = "$HOME/.nixpkgs/modules/darwin.nix"; } ];
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

    sketchybar --add alias "Control Center,Clock" right \
               --add alias "Control Center,WiFi" right \
               --add alias "Control Center,Battery" right \
               --add alias "Control Center,Sound" right \
               --set "Control Center,Sound" \
                      click_script="sketchybar -m --set \"\$NAME\" popup.drawing=toggle" \
                      popup.blur_radius=7 \
                      popup.background.corner_radius=5 \
                      popup.background.color=0x44000000 \
               --add slider volume.slider popup."Control Center,Sound" 100 \
               --set volume.slider \
                      background.padding_left=5 \
                      background.padding_right=5 \
                      slider.background.height=5 \
                      slider.background.corner_radius=5 \
                      slider.background.color=0x66000000 \
                      slider.highlight_color=0xccffffff \
                      slider.percentage=$(osascript -e "output volume of (get volume settings)") \
                      click_script="osascript -e \"set volume output volume \$PERCENTAGE\""

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
    "https://haskell-language-server.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
  ];
}
