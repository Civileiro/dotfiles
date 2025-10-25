lib:
let inherit (lib) mkOption types const;
in rec {
  mkOpt = type: default: mkOption { inherit type default; };

  mkOpt' = type: default: description:
    mkOption { inherit type default description; };

  mkConst = type: value:
    mkOption {
      inherit type;
      default = value;
      apply = const value;
    };

  mkBoolOpt = default:
    mkOption {
      inherit default;
      type = types.bool;
      example = true;
    };

  mkListOf = type: mkOpt (types.listOf type) [ ];
}
