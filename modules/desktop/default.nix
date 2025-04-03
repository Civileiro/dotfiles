{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.desktop;
in {
  options.modules.desktop = with types; {
    enable = mkEnableOption "Desktop Environment";
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
          assertion = !(length cfg.de == 0 && my.anySubmoduleEnabled cfg);
          message = "Can't enable a desktop app without a desktop environment";
        }
      ];

      modules.desktop.enable = mkDefault (cfg.x.enable || cfg.wayland.enable);

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
          nerd-fonts.fira-code
          noto-fonts-color-emoji
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
