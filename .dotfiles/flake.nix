{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    coffin.url = "git+https://git.nonsensical.dev/nonsensicaldev/coffin";
    coffin.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosModules = builtins.listToAttrs (map (x: {
      name = x;
      value = import (./modules + "/${x}");
    }) (builtins.attrNames (builtins.readDir ./modules)));

    nixosConfigurations =
      builtins.listToAttrs
      (
        map
        (x: {
          name = x;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              flake-self = self;
            };
            modules =
              builtins.attrValues self.nixosModules
              ++ [
                inputs.home-manager.nixosModules.home-manager
                inputs.lanzaboote.nixosModules.lanzaboote
                inputs.disko.nixosModules.disko
                "${./.}/machines/${x}/configuration.nix"
              ];
          };
        })
        (builtins.attrNames (builtins.readDir ./machines))
      );
    homeManagerModules =
      builtins.listToAttrs
      (
        map
        (name: {
          inherit name;
          value = import (./home-manager/modules + "/${name}");
        })
        (builtins.attrNames (builtins.readDir ./home-manager/modules))
      )
      // {
        nix = {...}: {
          imports = [
            inputs.nixvim.homeManagerModules.nixvim
            inputs.zen-browser.homeModules.beta
          ];
        };
      };
    homeConfigurations = {
      trident = {...}: {
        imports =
          [
            ./home-manager/profiles/desktop.nix
          ]
          ++ builtins.attrValues self.homeManagerModules;
      };
    };
    packages = forAllSystems (
      system: {
        default = self.nixosConfigurations.live.config.system.build.isoImage;
      }
    );
  };
}
