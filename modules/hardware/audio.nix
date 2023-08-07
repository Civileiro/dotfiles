{ config, lib, ... }:
with lib;
let cfg = config.modules.hardware.audio;
in {

  options.modules.hardware.audio = { enable = mkEnableOption "audio"; };

  config = mkIf cfg.enable {
    # Enable sound with pipewire.
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    user.extraGroups = [ "audio" ];

    security.rtkit.enable = true;
  };
}
