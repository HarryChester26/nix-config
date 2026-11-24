{
  description = "Shared macOS and Ubuntu development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      home-manager,
      spicetify-nix,
      ...
    }:
    let
      ubuntu = import ./hosts/ubuntu.nix;
    in
    {
      # macOS: sudo darwin-rebuild switch --flake .#hb
      darwinConfigurations.hb = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/macbook.nix
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hiepbui.imports = [
              ./home/common.nix
              ./home/darwin.nix
            ];
          }
          spicetify-nix.darwinModules.spicetify
        ];
      };

      # Ubuntu: home-manager switch --flake .#ubuntu
      homeConfigurations.ubuntu = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs ubuntu; };
        modules = [
          ./home/common.nix
          ./home/linux.nix
        ]
        ++ nixpkgs.lib.optionals ubuntu.enableSpicetify [
          spicetify-nix.homeManagerModules.spicetify
          ./modules/spicetify.nix
        ];
      };
    };
}
