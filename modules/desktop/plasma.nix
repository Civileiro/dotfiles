{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.plasma;
in {

  options.modules.desktop.plasma = { enable = mkEnableOption "KDE Plasma"; };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
      };
      desktopManager.plasma5.enable = true;

    };

    environment = {
      systemPackages = with pkgs; [
        libsForQt5.ark
        libsForQt5.filelight
        libsForQt5.ffmpegthumbs
        wineWowPackages.stable
      ];
      plasma5 = {
        excludePackages = with pkgs.libsForQt5; [
          elisa
          gwenview
          okular
          # oxygen
          khelpcenter
          konsole
          # plasma-browser-integration
          # print-manager
        ];
      };
    };
  };
}
