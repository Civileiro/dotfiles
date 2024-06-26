{ ... }: {
  imports = [ (import ./hardware-configuration.nix) ];

  # Configure console keymap
  console.keyMap = "br-abnt2";

  modules = {
    theme = {
      active = "catppuccin";
      catppuccin.flavour = "latte";
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
    };
    services = {
      docker.enable = true;
      networkmanager.enable = true;
    };
    desktop = {
      plasma.enable = true;
      apps = { discord.enable = true; };
      browsers = {
        default = "firefox";
        firefox.enable = true;
      };
      gaming = { steam.enable = true; };
      vm = { libvirt.enable = true; };
      media = {
        nomacs.enable = true;
        mpv.enable = true;
        libreoffice.enable = true;
        kate.enable = true;
      };
      terminal = {
        default = "alacritty";
        alacritty = {
          enable = true;
          fontsize = 14;
        };
      };
    };

  };

}
