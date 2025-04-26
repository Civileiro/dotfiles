{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.apps.mangohud;
in {
  options.modules.desktop.apps.mangohud = {
    enable = mkEnableOption "MangoHud";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ mangohud ];
    # put configuration files in .config/nvim
    home.config.file = {
      "MangoHud/MangoHud.conf".text = ''
        cpu_mhz
        cpu_power
        cpu_temp
        gpu_name
        gpu_power
        ram
        vram
      '';
    };
  };
}
