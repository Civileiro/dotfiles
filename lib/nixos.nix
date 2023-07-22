{ inputs, self, system, lib, pkgs, ... }:
{
  mkHost = hostPath:
    lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs self lib; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = lib.mkDefault (lib.removeSuffix ".nix" (builtins.baseNameOf hostPath));
        }
        hostPath
        self.root # can't directly access root ( ../. fails )
      ];
    };
}
