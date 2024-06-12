{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.hardware.nvidia;
in {

  options.modules.hardware.nvidia = {
    enable = mkEnableOption "Nvidia drivers";
    prime = {
      enable = mkEnableOption "Nvidia Prime";
      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA 
      nvidiaBusId = my.mkOpt types.str "";
      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA 
      intelBusId = my.mkOpt types.str "";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware = {
        nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.production;
          modesetting.enable = true;
          forceFullCompositionPipeline = true;
        };
        opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
        };
      };

      # fix for kernel 6.9 + wayland
      # https://www.reddit.com/r/NixOS/comments/1curi05/wayland_not_working_on_kernel_690/
      boot.kernelParams = [ "nvidia-drm.fbdev=1" ];

      services.xserver.videoDrivers = [ "nvidia" ];
      user.extraGroups = [ "video" ];

      environment.systemPackages = with pkgs;
        [
          # Respect XDG conventions, damn it!
          (writeScriptBin "nvidia-settings" ''
            #!${stdenv.shell}
            mkdir -p "$XDG_CONFIG_HOME/nvidia"
            exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings" "$@"
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
