{...}: {
  home.username = "trident";
  home.homeDirectory = "/home/trident";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];
  trident = {
    git.enable = true;
  };
}
