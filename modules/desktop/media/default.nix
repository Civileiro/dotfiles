# modules/desktop/media/default.nix

# All simple single package media stuff here

{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.media;
in {

  options.modules.desktop.media = {
    krita.enable = mkEnableOption "Krita";
    nomacs.enable = mkEnableOption "Nomacs";
    vlc.enable = mkEnableOption "VLC";
    mpv.enable = mkEnableOption "MPV";
    kate.enable = mkEnableOption "Kate";
    kdenlive.enable = mkEnableOption "Kdenlive";
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.krita.enable krita)
      (mkIf cfg.nomacs.enable nomacs)
      (mkIf cfg.vlc.enable vlc)
      (mkIf cfg.mpv.enable mpv)
      (mkIf cfg.kate.enable kdePackages.kate)
      (mkIf cfg.kdenlive.enable kdePackages.kdenlive)
    ];
  };

}
