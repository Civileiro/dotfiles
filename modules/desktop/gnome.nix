{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.desktop.gnome;
in {

  options.modules.desktop.gnome = {
    enable = mkEnableOption "Gnome";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "br";
      xkbVariant = "";
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      libinput = {
        mouse.naturalScrolling = false;
        touchpad.naturalScrolling = true;
      };

    };

  };
}
