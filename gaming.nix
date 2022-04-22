{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
    xboxdrv   # For Nintendo Switch pro controllers
    evtest
  ];

  programs.steam.enable = true;
  services.joycond.enable = true;

}

