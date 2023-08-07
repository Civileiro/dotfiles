{ self, config, options, lib, ... }:
with lib; {
  options = with types; {
    # Alias for users.users.${config.user.name}
    user = my.mkOpt attrs { };

    # Aliases for dotfiles directories
    dotfiles = {
      dir = my.mkOpt path self.root;
      binDir = my.mkOpt path "${config.dotfiles.dir}/bin";
      configDir = my.mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = my.mkOpt path "${config.dotfiles.dir}/modules";
      themesDir = my.mkOpt path "${config.dotfiles.modulesDir}/themes";
    };

    # Aliases for common directories
    home = {
      file = my.mkOpt' attrs { } "Files to place directly in $HOME";
      path = my.mkConst str config.user.home;
      config = {
        file = my.mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
        path = my.mkConst str
          config.home-manager.users.${config.user.name}.xdg.configHome;
      };
      data = {
        file = my.mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
        path = my.mkConst str
          config.home-manager.users.${config.user.name}.xdg.dataHome;
      };
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs (n: v:
        if isList v then concatMapStringsSep ":" toString v else (toString v));
      default = { };
      description = "System environment variables";
    };

    # Modules to be imported by home-manager
    hmModules = my.mkOpt (listOf anything) [ ];
  };

  config = {
    user = let
      name = assert lib.assertMsg (!elem self.user [ "" "root" ])
        "user cannot be empty or root";
        self.user;
    in {
      inherit name;
      description = name;
      isNormalUser = true;
      home = "/home/${name}";
      extraGroups = [ "wheel" ];
      uid = 1000;
    };
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      #   home.file        ->  home-manager.users.civi.home.file
      #   home.config.file  ->  home-manager.users.civi.xdg.configFile
      #   home.data.file    ->  home-manager.users.civi.xdg.dataFile

      users.${config.user.name} = {
        home = {
          username = config.user.name;
          homeDirectory = config.user.home;
          file = lib.mkAliasDefinitions options.home.file;
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.config.file;
          dataFile = mkAliasDefinitions options.home.data.file;
        };
        imports = config.hmModules;
      };
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    nix.settings = let users = [ "root" config.user.name ];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit = concatStringsSep "\n"
      (mapAttrsToList (n: v: ''export ${n}="${v}"'') config.env);
  };
}
