{
  description = "Civi's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      # Rust toolchain manager
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blocklist = {
      # network blocklist
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, fenix, ... }:
    let
      system = "x86_64-linux";
      additionalSelf = {
        user = "civi";
        root = ./.;
      };

      overlays = lib.attrValues (lib.my.mapModules import ./overlays)
        ++ [ fenix.overlays.default ];

      # extend lib with my own libraries in lib.my
      lib = nixpkgs.lib.extend (final: prev: { my = import ./lib final; });

      mkHost = hostPath:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs lib;
            self = self // additionalSelf;
          };
          modules = [
            {
              nixpkgs.overlays = overlays;
              networking.hostName = lib.mkDefault
                (lib.removeSuffix ".nix" (builtins.baseNameOf hostPath));
            }
            inputs.home-manager.nixosModules.home-manager
            inputs.blocklist.nixosModule
            inputs.nix-index-database.nixosModules.nix-index
            hostPath
          ]
          # All my personal modules
            ++ (lib.my.mapModulesRec' import ./modules);
        };
    in {
      nixosModules = lib.my.mapModulesRec import ./modules;

      nixosConfigurations = lib.my.mapModules mkHost ./hosts;
    };
}
