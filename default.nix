{ inputs, self, config, lib, pkgs, ... }:
let
  base = "/etc/nixpkgs/channels";
  nixpkgsPath = "${base}/nixpkgs";
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.blocklist.nixosModule
  ]
  # All my personal modules
    ++ (lib.my.mapModulesRec' import ./modules);

  environment = {
    systemPackages = with pkgs;
      lib.flatten [
        (lib.optional (!config.modules.editors.nvim.enable) neovim)
        wget
        git
        unzip
        file
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
        configurationLimit = 20;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
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
    package = pkgs.nixVersions.stable;

    registry.nixpkgs.flake = inputs.nixpkgs;

    nixPath = [
      "nixpkgs=${nixpkgsPath}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  systemd.tmpfiles.rules =
    [ "L+ ${nixpkgsPath}     - - - - ${inputs.nixpkgs}" ];

  # make a file with the name of all installed packages
  environment.etc."current-packages".text = with builtins;
    let
      packages = config.environment.systemPackages
        ++ config.users.users.${config.user.name}.packages;
      packageNames = map (p: "${p.name}") packages;
      sortedUnique = sort lessThan (lib.unique packageNames);
      formatted = concatStringsSep "\n" sortedUnique;
    in formatted;

  # Let 'nixos-version --json' know about the Git revision of this flake
  system.configurationRevision = lib.mkIf (self ? rev) self.rev;

  system.stateVersion = "22.05";
}
