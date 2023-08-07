{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.gaming.emulators;
in {
  options.modules.desktop.gaming.emulators = {
    psx.enable = mkEnableOption "Playstation Emulator";
    ds.enable = mkEnableOption "Nintendo DS Emulator";
    gb.enable = mkEnableOption "GameBoy + GameBoy Color Emulator";
    gba.enable = mkEnableOption "GameBoy Advance Emulator";
    snes.enable = mkEnableOption "Super Nintendo Emulator";
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.psx.enable epsxe)
      (mkIf cfg.ds.enable desmume)
      (mkIf (cfg.gba.enable || cfg.gb.enable || cfg.snes.enable) higan)
    ];
  };
}
