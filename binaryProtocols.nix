{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CAN
    can-utils

    # BACnet
    bacnet-stack
    setserial

    # Sniffing
    tcpdump

    minicom

  ];

  # clj-modbus & j2mod
  networking.firewall.allowedTCPPorts = [ 502 1503 1502 47808 ];
  networking.firewall.allowedUDPPorts = [ 502 1503 1502 47808 ];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
