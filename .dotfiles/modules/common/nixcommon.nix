{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs;};
    useUserPackages = true;
    backupFileExtension = "*.bkp";
  };

  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    optimise.automatic = true;
    gc = {
      persistent = true;
      automatic = true;
    };
    settings = {
      auto-optimise-store = true;

      trusted-users = ["root" "@wheel"];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
