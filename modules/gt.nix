# ~/NixFig/nixos/modules/green-tunnel.nix

{ config, pkgs, ... }:

{
  # 1. Install Green Tunnel
  environment.systemPackages = [
    pkgs.green-tunnel
  ];

  # 2. Create a systemd service to run it automatically
  systemd.services.green-tunnel = {
    description = "Green Tunnel DPI Bypass Service";
    wantedBy = [ "multi-user.target" ];
    # Wait for the network to be fully online before starting
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      # The command to run the service
      ExecStart = "${pkgs.green-tunnel}/bin/green-tunnel";
      Restart = "on-failure";
      # Run as your own user, as it doesn't need root
      User = "gray"; 
    };
  };

  # 3. Configure NixOS to use Green Tunnel as the system proxy
  # This tells all applications, including Netbird, to route traffic through it
  networking.proxy.default = "http://127.0.0.1:8000";
  networking.proxy.noProxy = "127.0.0.1,localhost";
  
  # Ensure the wait-online service is active
  networking.networkmanager.wait-online.enable = true;
}
