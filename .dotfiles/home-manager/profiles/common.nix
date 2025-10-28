{...}: {
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  trident = {
    git.enable = true;
  };
}
