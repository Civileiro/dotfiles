/** Function that extends lib with any custom function we have */
{ inputs, self, system, root, lib, pkgs, ... }:
let
  inherit (lib) makeExtensible attrValues foldr;

  modules = import ./modules.nix {
    inherit lib;
    self.attrs = import ./attrs.nix { inherit lib; };
  };

  mylib = makeExtensible (final: 
    modules.mapModules (file:
      import file { inherit inputs self system root lib pkgs; }
    ) ./. ) ;
in
mylib.extend (final: prev:
  foldr (a: b: a // b) {} (attrValues prev))