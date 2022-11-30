{user, pkgs, ...}:
{
  imports = [
    (import ./hardware-configuration.nix)
    (import ../../modules/desktop/plasma { drivers = [ "nvidia" ]; })
    (import ../../modules/shell/bash)
    (import ../../modules/etc/virt-manager)
    (import ../../modules/dev/docker)
  ];

  networking.hostName = "${user}-nixos-desktop";

  nixpkgs.overlays = [

  ];
}
