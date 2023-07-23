{ config, lib, ... }:

with builtins;
with lib;
let blocklist = fetchurl {
  url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
  sha256 = "sha256:0lpvxgkg516dj6hqkr4pm5wzmfa2gmxlbmzr0zd61zks596n308x";
};
in {
  networking.extraHosts = ''

    # Block garbage
    ${optionalString config.services.xserver.enable (readFile blocklist)}
  '';

}
