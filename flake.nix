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
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        #

        system = {
          primaryUser = "hiepbui";

          defaults = {
            dock = {
              autohide = true;
              mru-spaces = false;
              persistent-apps = [
                "/Applications/WezTerm.app/"
                "/Applications/Vivaldi.app"
                "/Applications/Discord.app/"
                "/Applications/Spotify.app/"
                "/System/Applications/Calendar.app"
              ];
            };

            finder = {
              AppleShowAllExtensions = true;
              FXPreferredViewStyle = "clmv";
              FXRemoveOldTrashItems = true;
            };

            loginwindow.LoginwindowText = "devops-toolbox";
            screencapture.location = "~/Pictures/screenshots";
            screensaver.askForPasswordDelay = 10;
            NSGlobalDomain = {
              AppleICUForce24HourTime = true;
              AppleInterfaceStyle = "Dark";
              KeyRepeat = 2;
            };
          };
        };

        users.users.hiepbui.home = "/Users/hiepbui"; # wtf is this
        security.pam.services.sudo_local.touchIdAuth = true;
        nixpkgs.config.allowUnfree = true;

        environment.systemPackages = [
          pkgs.neovim
          pkgs.nodejs
          pkgs.R
          pkgs.cargo
          pkgs.maccy
          pkgs.gh
          pkgs.statix
          pkgs.rectangle
          pkgs.nixfmt
          pkgs.fastfetch
          pkgs.ripgrep
          pkgs.lazygit
        ];

        fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.inter
        ];

        homebrew = {
          enable = true;
          brews = [
            "mas"
          ];
          casks = [
          ];

          masApps = {
          };

          onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
          };

        };

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mini
      darwinConfigurations."hb" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
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
              extraSpecialArgs = { inherit inputs; }; # ????
              users.hiepbui = import ./home.nix;
            };
          }

          spicetify-nix.darwinModules.spicetify
        ];
      };
    };
}
