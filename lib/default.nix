# * Function that extends lib with any custom function we have
lib:
let
  inherit (lib) makeExtensible attrValues foldr;

  modules = import ./modules.nix lib;

  mylib =
    makeExtensible (final: modules.mapModules (file: import file lib) ./.);
in mylib.extend (final: prev: foldr (a: b: a // b) { } (attrValues prev))
