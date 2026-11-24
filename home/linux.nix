{ pkgs, ubuntu, ... }:
{
  home.username = ubuntu.username;
  home.homeDirectory = ubuntu.homeDirectory;

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = (import ../modules/packages.nix { inherit pkgs; }) ++ [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.inter
  ];

  # Ubuntu's desktop, drivers, and system services remain managed by Ubuntu.
  # The MacBook's Xft.dpi is deliberately not imposed on this monitor.
}
