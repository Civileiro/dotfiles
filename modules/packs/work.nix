# modules/packs/work.nix

# Bunch of packages I dont care about that I need for making money

{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.packs.work;
in {
  options.modules.packs.work = {
    enable = mkEnableOption "Boring";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      awscli
      kubectl
      dbeaver
      lens
      google-chrome
      openvpn
      insomnia
      redis
    ];
  };
}

