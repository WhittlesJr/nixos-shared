{ lib, config, pkgs, ... }:
{
  boot = {
    zfs = {
      extraPools = [ "rpool" "bpool" ];
      forceImportAll = false;
    };

    supportedFilesystems = [ "zfs" ];

    tmpOnTmpfs = true;

  };
  
  fileSystems."/" = {
    fsType = "zfs";
    device = "rpool/ROOT/CRYPT/nixos";
  };

  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };
}
