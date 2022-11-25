{user, pkgs, ...}:
{
  imports = [
    (import ./hardware-configuration.nix)
    ((import ../../modules/desktop/plasma) { drivers = [ "nvidia" ]; })
    (import ../../modules/shell/bash)
    (import ../../modules/etc/virt-manager)
    (import ../../modules/dev/docker)
  ];

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
