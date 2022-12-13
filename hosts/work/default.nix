{ pkgs, ... }:
{
  imports = [
    (import ../../modules/dev/docker)
  ];
  # services.resolved.enable = true;
  # services.openvpn.servers = {
  #   ck = {
  #     config = ''
  #       config /home/civi/work/client.ovpn

  #       script-security 2
  #       up ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
  #       up-restart
  #       down ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
  #       down-pre
  #     '';
  #     # autoStart = true;
  #     # updateResolvConf = true;
  #   };
  # };
}