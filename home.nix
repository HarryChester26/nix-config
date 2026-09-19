{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ ./spicetify.nix ];
  home.stateVersion = "26.11";

  programs = {

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        ignoreAllDups = true;
        path = "$HOME/.zsh_history";
        ignorePatterns = [
          "rm *"
          "pkill *"
          "cp *"
        ];
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "always";
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      configFile = ./ohmyposh/zen.toml;
    };

  };
}
