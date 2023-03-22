{ makeDefault ? false }:
{ pkgs, user, ... }:
rec {
  environment.systemPackages =  [ pkgs.nushell ];
  environment.shells = if makeDefault then [ pkgs.nushell ] else [];
  users.users.${user}.shell = if makeDefault then pkgs.nushell else users.users.${user}.shell;
}