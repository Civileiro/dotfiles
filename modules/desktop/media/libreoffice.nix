# modules/desktop/media/documents.nix

{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.desktop.media.libreoffice;
in {

  options.modules.desktop.media.libreoffice = {
    enable = mkEnableOption "LibreOffice";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      libreoffice-qt
    ];
  };

}