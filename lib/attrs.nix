{ lib, ... }:
let
  inherit (builtins) any isAttrs;
  inherit (lib) mapAttrsToList count id;
in rec {

  countAttrs = pred: attrs: count id (mapAttrsToList pred attrs);

  anyAttrs = pred: attrs: any id (mapAttrsToList pred attrs);

  mapAttrsToListRec = pred: attrs:
    (mapAttrsToList (n: v: if isAttrs v then anyAttrsRec pred v else pred n v)
      attrs);

  anyAttrsRec = pred: attrs: any id (mapAttrsToListRec pred attrs);
}
