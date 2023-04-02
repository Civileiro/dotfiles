# modules/desktop/media/default.nix

# All simple single package media stuff here

{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.desktop.media;
in {

  options.modules.desktop.media = {
    krita.enable = mkEnableOption "Krita";
    nomacs.enable = mkEnableOption "Nomacs";
    vlc.enable = mkEnableOption "VLC";
    kate.enable = mkEnableOption "Kate";
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.krita.enable krita)
      (mkIf cfg.nomacs.enable nomacs)
      (mkIf cfg.vlc.enable vlc)
      (mkIf cfg.kate.enable kate)
    ];
  };

}