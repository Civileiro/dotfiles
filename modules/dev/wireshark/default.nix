{ user, ... }:
{
  users.users.${user}.extraGroups = [ "wireshark" ];

  programs.wireshark.enable = true;
}