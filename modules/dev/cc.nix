# modules/dev/cc.nix --- C & C++
#
# I liked C. I loved C++(17+). 
# Even after rust replaced it as my favorite language
# it still has a place in my heart

{ config, lib, pkgs, ... }:
with lib;
let devCfg = config.modules.dev;
    cfg = devCfg.cc;
in {
  options.modules.dev.cc = {
    enable = mkEnableOption "C/C++";
    install = my.mkBoolOpt false;
    lsp.enable = my.mkBoolOpt devCfg.lsp.enable;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; builtins.map (mkIf cfg.install) [
      clang
      gcc
      bear
      gdb
      cmake
      llvmPackages.libcxx
    ] ++ [
      (mkIf cfg.lsp.enable clang-tools)
    ];
  };
}
