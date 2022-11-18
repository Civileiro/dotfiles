{ user, config, pkgs, ... }:

{
  imports = [
    (import ../modules/editor/neovim)
  ];
  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = user;
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      firefox
      kate
      vlc
      vscode
      discord
      btop
      alacritty
      jetbrains.idea-community
      jetbrains.pycharm-community
      (python3.withPackages (py-packages: with py-packages; [
        pandas
        numpy
      ]))
      rustup
      krita
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
    alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.9;
        font = {
          normal.family = "FiraCode Nerd Font";
          size = 20;
        };
      };
    };
  };
}
