{ config, pkgs, ... }:
{
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
      "homebrew/cask-versions"
      "homebrew/services"
    ];

    casks = [ "keepassxc" ];
  };
}
