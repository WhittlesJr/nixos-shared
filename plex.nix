{ config, lib, pkgs, ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/media/.plex";
  };

  users.extraUsers.plex.extraGroups = [ "media" ];

  users.extraGroups = {
    media = {};
  };

  environment.systemPackages = with pkgs; [
    sqlite
  ];
}
