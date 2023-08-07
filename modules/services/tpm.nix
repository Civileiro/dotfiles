# modules/services/tpm.nix - https://nixos.wiki/wiki/TPM

{ config, lib, ... }:
with lib;
let cfg = config.modules.services.tpm;
in {
  options.modules.services.tpm = { enable = mkEnableOption "TPM2"; };

  config = mkIf cfg.enable {
    security.tpm2.enable = true;
    # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    security.tpm2.pkcs11.enable = true;
    # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
    security.tpm2.tctiEnvironment.enable = true;
    user.extraGroups = [ "tss" ]; # tss group has access to TPM devices
  };
}
