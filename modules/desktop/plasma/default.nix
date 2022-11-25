
{ drivers, ... }:
{ pkgs, ... }:
{

  hardware.opengl.enable = true;

  # Enable the X11 windowing system.
  # Enable the KDE Plasma Desktop Environment.
  # Configure keymap in X11
  services.xserver = {
    enable = true;
    layout = "br";
    xkbVariant = "";
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
    };
    desktopManager.plasma5 = {
      enable = true;
      excludePackages = with pkgs.libsForQt5; [
        elisa
        gwenview
        okular
        # oxygen
        khelpcenter
        konsole
        # plasma-browser-integration
        # print-manager
      ];
    };
    videoDrivers = drivers; 

  };

  environment = {
    systemPackages = with pkgs.libsForQt5; [
      ark
      filelight
    ];
  };
}
