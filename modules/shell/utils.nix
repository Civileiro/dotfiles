{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.shell.utils;
in {
  options.modules.shell.utils = { enable = mkEnableOption "Shell Utils"; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      btop # better top
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
