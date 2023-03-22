{user, pkgs, ...}:
{
  imports = [
    (import ./hardware-configuration.nix)
    (import ../work)
    (import ../../modules/desktop/plasma { drivers = [ "nvidia" ]; })
    # (import ../../modules/shell/bash)
    (import ../../modules/shell/nu { makeDefault = true; })
    (import ../../modules/etc/virt-manager)
    (import ../../modules/game/steam)
    (import ../college)
  ];

  networking.hostName = "${user}-nixos-desktop";
  services.xserver.wacom.enable = true;

  nixpkgs.overlays = [

  ];
}
