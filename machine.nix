{ lib, config, pkgs, ... }:
{
  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  services.fwupd.enable = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = false;
      };
    };

    zfs = {
      requestEncryptionCredentials = true;
      forceImportAll = false;
    };

    supportedFilesystems = [ "zfs" ];

    tmpOnTmpfs = true;
  };

  fileSystems."/" =
  { device = "rpool/crypt/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" =
  { device = "rpool/crypt/home";
    fsType = "zfs";
  };

  fileSystems."/var" =
  { device = "rpool/crypt/nixos/var";
    fsType = "zfs";
  };

  fileSystems."/nix" =
  { device = "rpool/crypt/nixos/nix";
    fsType = "zfs";
  };

  fileSystems."/var/tmp" =
  { device = "rpool/crypt/nixos/var/tmp";
    fsType = "zfs";
  };

  fileSystems."/var/cache" =
  { device = "rpool/crypt/nixos/var/cache";
    fsType = "zfs";
  };

  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };
}
