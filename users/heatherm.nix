{ lib, config, pkgs, ... }:
{
  users.extraUsers = {
    heatherm = {
      isNormalUser = true;
      uid = 1001;
      home = "/home/heatherm";
      hashedPassword = lib.fileContents ./heatherm.hashedPassword;
      description = "Heather Whitt";
      extraGroups = [
        "networkmanager"
        "input"
        "audio"
        "video"
        "cdrom"
        "media"
        "dialout"
        "scanner"
        "lp"
      ];
    };
  };
}
