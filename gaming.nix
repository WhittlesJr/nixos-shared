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

}

