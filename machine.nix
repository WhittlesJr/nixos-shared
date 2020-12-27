{ lib, config, pkgs, ... }:
{
  boot = {
    zfs = {
      enableUnstable = true;
      forceImportAll = false;
      extraPools = [ "bpool" ];
    };

    supportedFilesystems = [ "zfs" ];

    tmpOnTmpfs = true;

    # TODO: Right alt doesn't work with console TTY switching
    loader = {
      grub = {
        enable = true;
        version = 2;
        zfsSupport = true;
      };
    };
  };

  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "rpool/ROOT/nixos";
      fsType = "zfs";
    };
    "/etc" = {
      device = "rpool/ROOT/nixos/etc";
      fsType = "zfs";
    };
    "/var" = {
      device = "rpool/ROOT/nixos/var";
      fsType = "zfs";
    };
    "/var/tmp" = {
      device = "rpool/ROOT/nixos/var/tmp";
      fsType = "zfs";
    };
    "/var/cache" = {
      device = "rpool/ROOT/nixos/var/cache";
      fsType = "zfs";
    };
    "/boot" = {
      device = "bpool/BOOT/nixos";
      fsType = "zfs";
    };
  };
}
