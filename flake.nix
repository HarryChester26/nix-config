{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim.url = "github:pfassina/lazyvim-nix";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
      spicetify-nix,
      lazyvim,
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mini
      darwinConfigurations."hb" = nix-darwin.lib.darwinSystem {
        # A module in NixOS is a self-contained building block used to configure a specific part of your operating system.
        specialArgs = { inherit inputs; };
        modules = [
          # config file for OS configuration
          ./configuration.nix
          { system.configurationRevision = self.rev or self.dirtyRev or null; } # Set Git commit hash for darwin-version.

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "hiepbui";
              autoMigrate = true;
            };
          }

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # extraSpecialArgs = { inherit inputs; }; # read dependencies from flake inputs as they only available in the flake.nix
              users.hiepbui = import ./home.nix;
            };
          }

          spicetify-nix.darwinModules.spicetify
        ];
      };
    };
}
