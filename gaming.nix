{ config, pkgs, ... }:
{
  # A dependency of lutris, and was recently marked "insecure" (2020-05-05)
  nixpkgs.config.permittedInsecurePackages = [
    "p7zip-16.02"
  ];

  environment.systemPackages = with pkgs; [
    vulkan-headers
    wine
    geckodriver
    mono

    discord

    xboxdrv
    evtest

    lutris
    steam
    #linux-steam-integration
    protontricks


  ];

  services.udev.extraRules = ''
    # Nintendo Switch Pro Controller over USB hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:057E:2009.*", MODE="0666"

    # Nintendo Switch Pro Controller over bluetooth hidraw
    KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0666"

    # Permissions for /dev/uinput
    KERNEL=="uinput", MODE="0666", GROUP="users", OPTIONS+="static_node=uinput"
  '';
}

