{ config, lib, pkgs, ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  users.extraUsers.plex.extraGroups = [ "media" ];

  users.extraGroups = {
    media = {};
  };

  environment.systemPackages = with pkgs; [
    sqlite
  ];
}
