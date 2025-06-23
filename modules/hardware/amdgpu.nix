{ config, lib, ... }:
with lib;
let cfg = config.modules.hardware.amdgpu;
in {

  options.modules.hardware.amdgpu = {
    enable = mkEnableOption "Radeon drivers";
  };

  config = mkIf cfg.enable {
    hardware = {
      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        overdrive.enable = true;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    services.xserver.videoDrivers = [ "amdgpu" ];
    user.extraGroups = [ "video" ];

    services.lact.enable = true;
  };
}
