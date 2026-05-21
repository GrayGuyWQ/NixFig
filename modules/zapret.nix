# ~/NixFig/nixos/modules/zapret.nix

{ config, pkgs, ... }:

{
  # 1. Install Zapret
  environment.systemPackages = [
    pkgs.zapret
  ];

  # 2. Declaratively create the Zapret config file
  environment.etc."zapret/zapret.conf".text = ''
    nfqws-out-queue = 100
    split-http-req = 2
  '';

  # 3. Add firewall rules to divert traffic to Zapret
  networking.firewall.enable = true;
  networking.firewall.extraCommands = ''
    iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 80 -j NFQUEUE --queue-num 100
    iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 443 -j NFQUEUE --queue-num 100
  '';
}
