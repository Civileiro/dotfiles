{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.plasma;
in {

  options.modules.desktop.plasma = {
    enable = mkEnableOption "KDE Plasma";
    wayland.enable = mkEnableOption "KWayland";
  };

  config = mkIf cfg.enable {

    modules.desktop = {
      x.enable = true;
      wayland.enable = cfg.wayland.enable;
      de = [ "plasma" ];
    };

    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession =
          if cfg.wayland.enable then "plasmawayland" else "plasma";
        sddm = {
          enable = true;
          autoNumlock = true;
        };
      };
      desktopManager.plasma5.enable = true;

    };

    environment = {
      systemPackages = with pkgs; [
        libsForQt5.ark
        libsForQt5.filelight
        libsForQt5.ffmpegthumbs
        wineWowPackages.stable
        (if cfg.wayland.enable then wl-clipboard else xclip)
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
