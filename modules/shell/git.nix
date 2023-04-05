# /modules/shell/git.nix

# git is installed by default already
# this module is for git utilities and configuration

{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = mkEnableOption "git";
    gh = my.mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      git
      (mkIf cfg.gh gh)
    ];
  };
}