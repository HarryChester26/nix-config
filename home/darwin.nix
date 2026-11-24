{ lib, ... }:
{
  home.username = "hiepbui";
  home.homeDirectory = "/Users/hiepbui";

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Restore the original OmniWM configuration by adding this missing file.
  programs = lib.optionalAttrs (builtins.pathExists ../omniwm-settings.toml) {
    omniwm = {
      enable = true;
      settings = ../omniwm-settings.toml;
    };
  };
}
