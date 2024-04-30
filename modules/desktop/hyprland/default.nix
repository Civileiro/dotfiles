{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.desktop.hyprland;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.hyprland = { enable = mkEnableOption "Hyprland"; };

  config = mkIf cfg.enable {

    modules.desktop = {
      windowSystem = "wayland";
      de = [ "hyprland" ];
      hyprland.waybar.enable = true;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    env = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    environment.systemPackages = with pkgs; [
      dunst # notif daemon
      kitty
      rofi-wayland # app launcher
      networkmanagerapplet
      dolphin # file explorer
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

  };
}
