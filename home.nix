{ pkgs, ... }:
{
  home.stateVersion = "25.11";

  programs = {

    wezterm = {
      enable = true;
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
      options = [
        "--cmd cd"
      ];
    };

    eza = {
      enable = true;
      icons = "always";
    };

  };
}
