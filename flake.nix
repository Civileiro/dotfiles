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
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true; # sorry Stallman
      };

      # extend lib with out own libraries in lib.my
      lib = nixpkgs.lib.extend (final: prev: {
        my = import ./lib {
          inherit inputs system pkgs;
          self = self // additionalSelf;
          lib = final;
        };
      });
    in {
      nixosModules = lib.my.mapModulesRec import ./modules;

      nixosConfigurations = lib.my.mapModules lib.my.mkHost ./hosts;
    };
}
