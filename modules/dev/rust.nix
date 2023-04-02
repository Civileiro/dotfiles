# modules/dev/rust.nix --- https://rust-lang.org

{ config, lib, pkgs, ... }:
with lib;
let devCfg = config.modules.dev;
    cfg = devCfg.rust;
in {
  options.modules.dev.rust = {
    enable = mkEnableOption "Rust";
    xdg.enable = my.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = [ pkgs.rustup ];
    }
    (mkIf cfg.xdg.enable {
      env.RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      env.CARGO_HOME = "$XDG_DATA_HOME/cargo";
      env.PATH = [ "$CARGO_HOME/bin" ];
    })
  ]);
}