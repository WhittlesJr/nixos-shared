{ config , pkgs , ... }:
{
  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs; [
    bluez-tools
    bluez.dev

    cmake
    gnumake
    gcc
    boost
    pkgconfig
  ];
}
