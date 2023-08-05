{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.hardware.nvidia;
in {

  options.modules.hardware.nvidia = {
    enable = mkEnableOption "Nvidia drivers";
    prime = {
      enable = mkEnableOption "Nvidia Prime";
      nvidiaBusId = my.mkOpt types.str "";
      intelBusId = my.mkOpt types.str "";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware = {
        nvidia = {
          modesetting.enable = true;
          forceFullCompositionPipeline = true;
        };
        opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
        };
      };

      services.xserver.videoDrivers = [ "nvidia" ];
      user.extraGroups = [ "video" ];

      environment.systemPackages = with pkgs;
        [
          # Respect XDG conventions, damn it!
          (writeScriptBin "nvidia-settings" ''
            #!${stdenv.shell}
            mkdir -p "$XDG_CONFIG_HOME/nvidia"
            exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
          '')
        ];
    }
    (mkIf cfg.prime.enable {
      hardware.nvidia.prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = cfg.prime.intelBusId;
        nvidiaBusId = cfg.prime.nvidiaBusId;
      };
    })
  ]);
}
