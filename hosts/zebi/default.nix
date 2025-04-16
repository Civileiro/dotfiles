{ config, ... }: {
  imports = [ (import ./hardware-configuration.nix) ];

  # Configure console keymap
  console.keyMap = "br-abnt2";

  modules = {
    theme = {
      active = "catppuccin";
      catppuccin.flavour = "mocha";
    };
    shell = {
      zsh.enable = true;
      git.enable = true;
      tmux.enable = true;
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
      nix.enable = true;
      haskell.enable = true;
      js.enable = true;
    };
    services = {
      docker.enable = true;
      transmission = {
        enable = true;
        folder = "${config.user.home}/mass/torrents";
      };
      networkmanager.enable = true;
    };
    desktop = {
      plasma.enable = true;
      apps = {
        discord.enable = true;
        piper.enable = true;
        obs.enable = true;
        mangohud.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
      };
      gaming = {
        steam.enable = true;
        emulators = { gba.enable = true; };
      };
      vm = { libvirt.enable = true; };
      media = {
        krita.enable = true;
        nomacs.enable = true;
        mpv.enable = true;
        libreoffice.enable = true;
        kate.enable = true;
        kdenlive.enable = true;
      };
      terminal = {
        default = "kitty";
        kitty = {
          enable = true;
          fontsize = 14;
        };
      };
    };
  };

}
