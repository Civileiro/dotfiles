{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop;
  x = config.services.xserver.enable;
in {
  options.modules.desktop = with types; {
    x.enable = mkEnableOption "X";
    wayland.enable = mkEnableOption "Wayland";
    de = my.mkOpt (listOf str) [ ];
  };
  config = mkMerge [
    {
      assertions = [
        {
          assertion = length cfg.de < 2;
          message =
            "Can't have more than one desktop environment enabled at a time";
        }
        {
          assertion = (length cfg.de == 1) || !(anyAttrs
            (n: v: isAttrs v && anyAttrs (n: v: isAttrs v && v.enable)) cfg);
          message = "Can't enable a desktop app without a desktop environment";
        }
      ];

      fonts = {
        fontDir.enable = true;
        enableGhostscriptFonts = true;
        packages = with pkgs; [
          ubuntu_font_family
          dejavu_fonts
          symbola
          carlito # NixOS
          vegur # NixOS
          source-code-pro
          jetbrains-mono
          font-awesome # Icons
          corefonts # MS
          (nerdfonts.override {
            # Nerdfont Icons override
            fonts = [ "FiraCode" ];
          })
        ];
      };
    }
    (mkIf cfg.x.enable {
      services.xserver = {
        xkb = {
          layout = "br";
          variant = "";
        };
        libinput = {
          mouse.naturalScrolling = false;
          touchpad.naturalScrolling = true;
        };
      };
    })
    (mkIf cfg.wayland.enable { env = { NIXOS_OZONE_WL = "1"; }; })
  ];
}
