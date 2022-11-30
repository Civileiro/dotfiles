{user, pkgs, ...}:
{
  imports = [
    (import ./hardware-configuration.nix)
    (import ../work)
    (import ../../modules/desktop/plasma { drivers = [ "nvidia" ]; })
    (import ../../modules/shell/bash)
    (import ../../modules/etc/virt-manager)
  ];

  networking.hostName = "${user}-nixos-desktop";

  nixpkgs.overlays = [

  ];
}
