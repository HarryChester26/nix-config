{
  lib,
  ...
}:
{
  home.stateVersion = "26.11";
  # If you restore these optional Lua files at the repository root, Home Manager
  # will also deploy them. Existing unmanaged files are left alone if absent.
  xdg.configFile =
    lib.optionalAttrs (builtins.pathExists ../constants.lua) {
      "wezterm/constants.lua".source = ../constants.lua;
    }
    // lib.optionalAttrs (builtins.pathExists ../commands.lua) {
      "wezterm/commands.lua".source = ../commands.lua;
    };

  programs = {

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ../wezterm.lua;
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
      configFile = ../ohmyposh/zen.toml;
    };

  };
}
