{ inputs, pkgs, ... }: {

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      theme = spicePkgs.themes.starryNight;

      enabledExtensions = with spicePkgs.extensions; [
        volumePercentage
        betterGenres
        fullScreen
        spicyLyrics
        hidePodcasts
        shuffle
      ];
    };
}
