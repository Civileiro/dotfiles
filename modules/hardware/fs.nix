{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.hardware.fs;
in {
  options.modules.hardware.fs = {
    enable = mkEnableOption "Filesystem Support";
  };
  config = mkIf cfg.enable {

    # Support for more filesystems, mostly to support external drives
    environment.systemPackages = with pkgs; [
      # sshfs
      exfat     # Windows drives
      ntfs3g    # Windows drives
      # hfsprogs  # MacOS drives
    ];
  };
}
