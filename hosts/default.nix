{user, system, nixpkgs, lib, home-manager, ...}:
{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user lib; };
    modules = [
      ./desktop
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ ./home.nix ];
        };
      }
    ];
  };
}