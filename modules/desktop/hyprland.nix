{ inputs, config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Hyprland";
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland = {
        enable= true;
        hidpi = true;
      };
    };
    services.xserver = {
      enable = true;
      
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
      };
    };
    hmModules = [
      #inputs.hyprland.homeManagerModules.default
    ];
  };
}
