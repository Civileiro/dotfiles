{ inputs, self, system, root, lib, pkgs, ... }:
{
  mkHost = hostPath:
    lib.nixosSystem {
      inherit system;
      specialArgs = { inherit root inputs self lib; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = lib.mkDefault (lib.removeSuffix ".nix" (builtins.baseNameOf hostPath));
        }
        hostPath
        root # default.nix
      ];
    };
}