{ ... }: {
  config = {
    networking = {
      # blocklist
      stevenBlackHosts.enable = true;
    };
  };
}
