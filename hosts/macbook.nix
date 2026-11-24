{ pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../modules/spicetify.nix
  ];

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

  users.users.hiepbui.home = "/Users/hiepbui";
  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = (import ../modules/packages.nix { inherit pkgs; }) ++ [
    pkgs.maccy
    pkgs.rectangle
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
      "tor-browser"
    ];

    masApps = {
    };

    onActivation = {
      cleanup = "none"; # Avoid removing unmanaged Homebrew applications.
      autoUpdate = true;
      upgrade = true;
    };

  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
