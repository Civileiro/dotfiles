{
  description = "Civi's flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let

      system = "x86_64-linux";

      root = ./.;

      makePkgs = pkgs: overlays: import pkgs {
        inherit system overlays;
        config.allowUnfree = true; # sorry Stallman
      };
      pkgs = makePkgs nixpkgs self.overlays;

      # extend lib with out own libraries in lib.my
      lib = nixpkgs.lib.extend (final: prev: 
        { my = import ./lib { inherit inputs self system root pkgs; lib = final; }; });
    in {

      overlays = lib.attrValues (lib.my.mapModules import ./overlays);

      nixosModules = lib.my.mapModulesRec import ./modules;

      nixosConfigurations = lib.my.mapModules lib.my.mkHost ./hosts;

    };
}
