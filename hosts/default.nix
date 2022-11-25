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
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user lib; };
    modules = [
      ./laptop
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
<<<<<<< HEAD
        home-manager.user.${user} = {
=======
        home-manager.users.${user} = {
>>>>>>> cd4dd52 (added laptop host)
          imports = [ ./home.nix ];
        };
      }
    ];
  };
}
