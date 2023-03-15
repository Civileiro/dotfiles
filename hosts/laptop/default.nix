{user, pkgs, ...}:
{
  imports = [
    (import ./hardware-configuration.nix)
    # (import ../work)
    (import ../../modules/desktop/plasma { drivers = [ "amdgpu" ]; })
    (import ../../modules/shell/bash)
    # (import ../../modules/etc/virt-manager)
    (import ../../modules/etc/print)
    (import ../college)
  ];

  networking.hostName = "${user}-nixos-laptop";
  hardware.bluetooth.enable = true;
  

  nixpkgs.overlays = [

  ];
}
