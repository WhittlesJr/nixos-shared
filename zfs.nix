{ lib, config, pkgs, ... }:
{
  boot = {
    kernelParams = [ "zfs.zfs_arc_max=2147483648" ];
    zfs = {
      requestEncryptionCredentials = true;
      forceImportAll = false;
      #zed = {
      #  enableMail = true;
      #};
    };
    supportedFilesystems = [ "zfs" ];
  };

  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };

  #swapDevices = [
  #  {
  #    device = "/dev/zvol/rpool/swap";
  #  }
  #];

  fileSystems."/" = {
    device = "rpool/crypt/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/crypt/home";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "rpool/crypt/nixos/var";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/crypt/nixos/nix";
    fsType = "zfs";
  };

  fileSystems."/var/tmp" = {
    device = "rpool/crypt/nixos/var/tmp";
    fsType = "zfs";
  };

  fileSystems."/var/cache" = {
    device = "rpool/crypt/nixos/var/cache";
    fsType = "zfs";
  };

  #programs.msmtp = {
  #  enable = true;
  #  setSendmail = true;
  #  defaults = {
  #    aliases = "/etc/aliases";
  #    port = 465;
  #    tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
  #    tls = "on";
  #    auth = "login";
  #    tls_starttls = "off";
  #  };
  #  accounts = {
  #    default = {
  #      host = "smtp.gmail.com";
  #      port = 587;
  #      passwordeval = "gpg --quiet --for-your-eyes-only --no-tty --decrypt ~/.mail/.msmtp-credentials.gpg";
  #      from = "alex.joseph.whitt@gmail.com";
  #      user = "alex.joseph.whitt";
  #    };
  #  };
  #};

}
