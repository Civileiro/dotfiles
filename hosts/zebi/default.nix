{ ... }:
{
  imports = [
    (import ./hardware-configuration.nix)
  ];

    # Configure console keymap
  console.keyMap = "br-abnt2";

  modules = {
    shell = {
      nu.enable = true;
      git.enable = true;
      utils = {
        file.enable = true;
        btop.enable = true;
      };
    };
    services = {
      docker.enable = true;
      transmission.enable = true;
      tpm.enable = true;
      networkmanager.enable = true;
    };
    desktop = {
      plasma.enable = true;
      apps = {
        discord.enable = true;
        wireshark.enable = true;
        vscode.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
      };
      gaming = {
        steam.enable = true;
      };
      vm = {
        libvirt.enable = true;
      };
      media = {
        krita.enable = true;
        nomacs.enable = true;
        vlc.enable = true;
        libreoffice.enable = true;
        kate.enable = true;
      };
      terminal = {
        default = "alacritty";
        alacritty = {
          enable = true;
          fontsize = 20;
        };
      };
    };
    editors = {
      default = "nvim";
      nvim.enable = true;
    };
    dev = {
      xdg.enable = true;
      rust.enable = true;
      python.enable = true;
      cc.enable = true;
    };


    packs.work.enable = true;
  };

}