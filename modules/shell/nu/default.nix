{ makeDefault ? false }:
{ pkgs, user, ... }:
rec {
  environment.systemPackages =  [ pkgs.nushell pkgs.starship ];
  environment.shells = if makeDefault then [ pkgs.nushell ] else [];
  users.users.${user}.shell = if makeDefault then pkgs.nushell else users.users.${user}.shell;
}