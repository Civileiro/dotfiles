{user, pkgs, ...}:
{
  imports = [
    (import ./hardware-configuration.nix)
    (import ../../modules/desktop/plasma)
    (import ../../modules/shell/bash)
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 1; 
    };
  };
  networking.hostName = "${user}-nixos-desktop";

  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: {
          srs = builtins.fetchTarball {
            url = "https://discord.com/api/download?platform=linux&format=tar.gz"; 
            sha256 = "1pw9q4290yn62xisbkc7a7ckb1sa5acp91plp2mfpg7gp7v60zvz";
          };
        }
      );
    })
  ];
}