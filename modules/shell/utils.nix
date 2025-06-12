{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.shell.utils;
  hwCfg = config.modules.hardware;
in {
  options.modules.shell.utils = { enable = mkEnableOption "Shell Utils"; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (if hwCfg.amdgpu.enable then
        btop-rocm
      else if hwCfg.nvidia.enable then
        btop-cuda
      else
        btop) # better top with gpu monitoring
      bat # better cat
      eza # better ls
      fzf # GOAT
      ripgrep
      fd # better find
      hyfetch # this is 100% always necessary
      fastfetch # trust me
      pciutils
    ];

    environment.shellAliases = {

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      mkdir = "mkdir -pv";

      home = "cd;clear";

      eza =
        "eza --group-directories-first --git --icons --time=modified --time-style=relative";
      ls = "eza";
      ll = "eza -lhF";
      l = "eza -ahlF";

      neofetch = "hyfetch -b fastfetch";

      #  ns="nix-shell"
      #  nixos-build="nixos-rebuild build --flake"
      #  nixos-test="sudo nixos-rebuild test --flake"
      #  nixos-switch="sudo nixos-rebuild switch --flake"
    };
  };

}
