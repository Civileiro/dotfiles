{ pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
      # sessionVariables = {
      #   PS1 = "\\[\\u\\]$";
      # };
      bashrcExtra = builtins.readFile ./extra.bashrc;
    };
  };
}