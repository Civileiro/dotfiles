{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.plasma;
in {

  options.modules.desktop.plasma = { enable = mkEnableOption "KDE Plasma"; };

  config = mkIf cfg.enable {

    modules.desktop = {
      wayland.enable = true;
      de = [ "plasma" ];
    };

    services = {
      displayManager = {
        # wayland default
        defaultSession = "plasma";
        sddm = {
          wayland.enable = true;
          enable = true;
          autoNumlock = true;
        };
      };
      desktopManager.plasma6.enable = true;

    };

    environment = {
      systemPackages = with pkgs; [
        sddm
        libsForQt5.ark
        libsForQt5.filelight
        libsForQt5.ffmpegthumbs
        wineWowPackages.stable
        wl-clipboard
      ];
      plasma6 = {
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
