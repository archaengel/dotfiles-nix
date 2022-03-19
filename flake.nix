{
  description = "Archaengel's System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";


    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, darwin, darwin-stable, neovim-nightly-overlay, nixpkgs, home-manager, ... }@inputs: 
  let
    inherit (darwin.lib) darwinSystem;
    inherit (home-manager.lib) homeManagerConfiguration;
    isDarwin = system: (builtins.elem system nixpkgs.lib.platforms.darwin);
    homePrefix = system: if isDarwin system then "/Users" else "/home";
  in {
    darwinConfigurations."1134" = darwinSystem rec {
      system = "x86_64-darwin";
      modules = [
        ./modules/darwin.nix
        home-manager.darwinModules.home-manager
        ./modules/home-manager.nix
        ./modules/brew.nix
      ];
      specialArgs = {
        inherit system nixpkgs inputs;
        stable = darwin-stable;
      };
    };

    homeConfigurations.god-intel = homeManagerConfiguration rec {
      system = "x86_64-darwin";
      username = "god";
      homeDirectory = "${homePrefix system}/{username}";
      extraSpecialArgs = { inherit system nixpkgs inputs; };
      configuration = {
        nixpkgs.overlays = [neovim-nightly-overlay.overlay];
        imports = [ ./modules/overlays.nix ./modules/home-manager.nix ];
      };
    };
  };
}
