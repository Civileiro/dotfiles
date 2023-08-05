{ config, lib, pkgs, ... }:

with lib;
let 
  cfg = config.modules.desktop;
  x = config.services.xserver.enable;
in {
  config = mkIf x {
    assertions = [
      {
        assertion = (my.countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message = "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion =
          let srv = config.services;
          in srv.xserver.enable ||
             srv.sway.enable ||
             !(anyAttrs
               (n: v: isAttrs v &&
                      anyAttrs (n: v: isAttrs v && v.enable))
               cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    services.xserver = {
      layout = "br";
      xkbVariant = "";
      libinput = {
        mouse.naturalScrolling = false;
        touchpad.naturalScrolling = true;
      };
    };

    environment.systemPackages = with pkgs; [
      xclip
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

  };
}
