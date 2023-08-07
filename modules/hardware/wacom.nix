{ config, lib, ... }:
with lib;
let cfg = config.modules.hardware.wacom;
in {
  options.modules.hardware.wacom = { enable = mkEnableOption "Wacom drivers"; };

  config = mkIf cfg.enable {
    # For my intuos4 pro. Doesn't work for cintiqs.
    services.xserver.wacom.enable = true;
    # # TODO Move this to udev
    # system.userActivationScripts.wacom = ''
    #   # lock tablet to main display
    #   if xinput list --id-only "Wacom Intuos Pro S Pen stylus" 2>&1 >/dev/null; then
    #     xinput map-to-output $(xinput list --id-only "Wacom Intuos Pro S Pen stylus") DVI-I-1
    #     xinput map-to-output $(xinput list --id-only "Wacom Intuos Pro S Pen eraser") DVI-I-1
    #     xinput map-to-output $(xinput list --id-only "Wacom Intuos Pro S Pen cursor") DVI-I-1
    #   fi
    # '';
  };
}
