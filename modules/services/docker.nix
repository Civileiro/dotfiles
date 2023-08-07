{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.services.docker;
in {
  options.modules.services.docker = { enable = mkEnableOption "Docker"; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ docker docker-compose ];

    env.DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    env.MACHINE_STORAGE_PATH = "$XDG_DATA_HOME/docker/machine";

    user.extraGroups = [ "docker" ];

    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
        enableOnBoot = mkDefault false;
        # listenOptions = [];
      };
    };
  };
}
