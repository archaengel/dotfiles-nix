{ config, pkgs, ... }: {
  homebrew = {
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    enable = true;

    global = {
      brewfile = true;
      lockfiles = false;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];

    casks = [ "keepassxc" ];
  };
}
