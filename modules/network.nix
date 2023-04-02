{ config, lib, ... }:

with builtins;
with lib;
let blocklist = fetchurl {
  url = https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
  sha256 = "bad36e1c4cc3e6939e6d90791a2dc6e78905cb162338d0b8c1846361e710fe12";
};
in {
  networking.extraHosts = ''

    # Block garbage
    ${optionalString config.services.xserver.enable (readFile blocklist)}
  '';

}