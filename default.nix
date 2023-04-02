{ inputs, self, config, lib, pkgs, ... }:

{
  imports = 
      # I use home-manager to deploy files to $HOME; little else
    [ inputs.home-manager.nixosModules.home-manager ]
    # All my personal modules
    ++ ( lib.my.mapModulesRec' import ./modules );


  environment = {
    systemPackages = with pkgs; [ 
      neovim
      wget
      git
      neofetch # this is 100% always necessary trust me
      unzip
    ];
  };

  env = {
    DOTFILES = config.dotfiles.dir;
    DOTFILES_BIN = config.dotfiles.binDir;
  };


  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 1;
    };
  };

  # Set your time zone.
  time.timeZone = lib.mkDefault "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.utf8";
    LC_IDENTIFICATION = "pt_BR.utf8";
    LC_MEASUREMENT = "pt_BR.utf8";
    LC_MONETARY = "pt_BR.utf8";
    LC_NAME = "pt_BR.utf8";
    LC_NUMERIC = "pt_BR.utf8";
    LC_PAPER = "pt_BR.utf8";
    LC_TELEPHONE = "pt_BR.utf8";
    LC_TIME = "pt_BR.utf8";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # make a file with the name of all installed packages
  environment.etc."current-system-packages".text = 
    with builtins; let
      packages = map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = sort lessThan (lib.unique packages);
      formatted = concatStringsSep "\n" sortedUnique;
    in formatted;
  
  # Let 'nixos-version --json' know about the Git revision of this flake
  system.configurationRevision = lib.mkIf (self ? rev) self.rev;

  system.stateVersion = "22.05";
}
