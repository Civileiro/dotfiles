{ pkgs, ... }:
{
  programs = {
    bash = {
      promptInit = builtins.readFile ./promptInit;
    };
  };
}