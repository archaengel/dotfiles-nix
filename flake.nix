{
  description = "Archaengel's System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    unison-lang = {
      url = "github:ceedubs/unison-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:archaengel/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      darwin,
      darwin-stable,
      nixpkgs,
      home-manager,
      unison-lang,
      ...
    }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      isDarwin = system: (builtins.elem system nixpkgs.lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";
    in
    {
      darwinConfigurations."1134" = darwinSystem rec {
        system = "x86_64-darwin";
        modules = [
          ./modules/darwin.nix
          home-manager.darwinModules.home-manager
          ./modules/home-manager.nix
          ./modules/brew.nix
          {
            nixpkgs.overlays = [ unison-lang.overlay ];
            home-manager.extraSpecialArgs = {
              username = "god";
            };
          }
        ];
        specialArgs = {
          inherit system nixpkgs inputs;
          username = "god";
          stable = darwin-stable;
        };
      };

      homeConfigurations.god-intel = homeManagerConfiguration rec {
        system = "x86_64-darwin";
        username = "god";
        homeDirectory = "${homePrefix system}/${username}";
        extraSpecialArgs = {
          inherit
            system
            nixpkgs
            inputs
            username
            ;
        };
        configuration = {
          imports = [
            ./modules/overlays.nix
            ./modules/home-manager.nix
          ];
        };
      };
    };
}
