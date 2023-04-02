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
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        clang
        gcc
        bear
        gdb
        cmake
        llvmPackages.libcxx
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}