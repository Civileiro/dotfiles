{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.desktop.vm.libvirt;
in {
  options.modules.desktop.vm.libvirt = {
    enable = mkEnableOption "Virt-manager";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = [ pkgs.virt-manager ];
    user.extraGroups = [ "libvirtd" ];
  };

}
