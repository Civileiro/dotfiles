{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.apps.obs;
in {
  options.modules.desktop.apps.obs = { enable = mkEnableOption "OBS Studio"; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ obs-studio ];
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };
    security.polkit.enable = true;
  };
}
