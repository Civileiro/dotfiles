{ lib, ... }:
with builtins;
with lib; rec {
  # attrsToList :: attrs -> [{name value}]
  attrsToList = attrs:
    mapAttrsToList (name: value: { inherit name value; }) attrs;

  countAttrs = pred: attrs:
    count (attr: pred attr.name attr.value) (attrsToList attrs);
}
