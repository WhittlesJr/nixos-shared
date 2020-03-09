{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lutris
    vulkan-headers
    wine
    geckodriver
    mono

    protonvpn-cli
  ];

}

