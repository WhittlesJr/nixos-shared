{
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  users.extraUsers.plex.extraGroups = [ "media" ];

  users.extraGroups = {
    media = {};
  };
}
