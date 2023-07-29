# modules/dev/rust.nix --- https://rust-lang.org

{ config, lib, pkgs, ... }:
with lib;
let devCfg = config.modules.dev;
    cfg = devCfg.rust;
in {
  options.modules.dev.rust = {
    enable = mkEnableOption "Rust";
    components = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Rust components to be installed";
    };
    lsp.enable = my.mkBoolOpt devCfg.lsp.enable;
    formatter.enable = my.mkBoolOpt devCfg.formatter.enable;
    linter.enable = my.mkBoolOpt devCfg.linter.enable;
    xdg.enable = my.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      modules.dev.rust.components = let
        # Always install the Rust compiler, standard library and cargo
        base = [ "rustc" "rust-src" "cargo" ]; 
        lsp = if cfg.lsp.enable then [ "rust-analyzer" ] else [];
        formatter = if cfg.formatter.enable then [ "rustfmt" ] else [];
        linter = if cfg.linter.enable then [ "clippy" ] else [];
        in unique (base ++ lsp ++ formatter ++ linter);
      user.packages = [( pkgs.fenix.stable.withComponents cfg.components )];
      # rust needs llvm
      modules.dev.cc = {
        enable = true;
        install = true;
      };
    }
    (mkIf cfg.xdg.enable {
      env.RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      env.CARGO_HOME = "$XDG_DATA_HOME/cargo";
      env.PATH = [ "$CARGO_HOME/bin" ];
    })
  ]);
}
