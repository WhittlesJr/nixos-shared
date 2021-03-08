{ lib, config, pkgs, ... }:
{
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
      };
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

  fileSystems."/boot" =
  { device = "bpool/BOOT/nixos";
    fsType = "zfs";
  };
  
  fileSystems."/" =
  { device = "rpool/CRYPT/ROOT/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" =
  { device = "rpool/CRYPT/home";
    fsType = "zfs";
  };

  fileSystems."/var" =
  { device = "rpool/CRYPT/ROOT/nixos/var";
    fsType = "zfs";
  };

  fileSystems."/nix" =
  { device = "rpool/CRYPT/ROOT/nixos/nix";
    fsType = "zfs";
  };

  fileSystems."/var/tmp" =
  { device = "rpool/CRYPT/ROOT/nixos/var/tmp";
    fsType = "zfs";
  };

  fileSystems."/var/cache" =
  { device = "rpool/CRYPT/ROOT/nixos/var/cache";
    fsType = "zfs";
  };

  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };
}
