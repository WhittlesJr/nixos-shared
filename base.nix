{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.base;
in
{
  options.base = with types; {
    hostName = mkOption {
      type = str;
    };
  };

  config = {

    deployment.targetHost = cfg.hostName;

    nix.nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
      "nixos-config=/etc/nixos/machines/${cfg.hostName}.nix"
    ];

    networking.hostName = cfg.hostName;

    users.extraUsers = {
      root = {
        hashedPassword = lib.fileContents ./users/root.hashedPassword;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrImXlLCT+qWOjg1rrelUTaUCBurdxf55lWUE0HNua1P5XcErITmRHAsNOWfM0ZMLSpyNWBcNh2XZYhkyCUVsWmEHFXX/xye8o3M0DUqgcxKl//MQ21vzGeVwC7+ierkDScvbh1hW6iDF31Jtu+oYozcu9s/Y+jBOILf/yVzUWayptQcdSyZanYq1A3D5jZZBFOb40E7mv0GR3UAgx7OAHo30Lwl6m1zth3NkiADdRlrTnwkHlcjzX4CLvdh12pBIU+JfpNbaQRJneH+s4YrYgvWsXVVWKfiBzf+OO5xgAEhAXl4Iz4H1u2CSqfG2FDNghHT8fWLRpvIJWJWrl1/FRVQtaAAUGul8E/tmPBPWCmp+/CdbGJ7Skx397tUGL8fkYDa6LzSk9s9EQBxb1yubv65hi8TBLepd4fd+bxOm4+gey2ZHqMIbQQeFRwBMJNZCCBuxagL1GHvUyW5o3qTiIMzw0KOHjy9QkfRWlkTuFHCwYZyL5T4hNFwP7xqFH+ad9Ybd+/ctSShcDcCDqDu6orAUd/D3+NbHpLK7PlKzcivQCvIUoocy7WTNix80pWP8wl2IDK0jr3ZJydHMRk79kp2WE4fOKxeK/UiRmqaU+5QkQn5+yKo3d1DKpUtOJTdj8YzQa3+1J5aAohO1vMxl9RCVweEDKVQbuteQ31WQZ9w== alex.joseph.whitt@gmail.com"
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      cowsay
      dnsutils
      fortune
      git
      gitAndTools.gitflow
      gnupg
      gparted
      gptfdisk
      inetutils
      iputils
      iotop
      killall
      lshw
      lsof
      minicom
      mkpasswd
      ncdu
      nix-index
      nixops
      nixpkgs-review
      nix-index
      nix-prefetch
      nix-prefetch-git
      ntfs3g
      openssl
      p7zip
      parted
      patchutils
      pciutils
      psmisc
      sl
      smartmontools
      tmux
      tree
      unzip
      usbutils
      vim
      wget
      zip
    ];

    nixpkgs.config.allowUnfree = true;

    i18n.defaultLocale = "en_US.UTF-8";

    users.mutableUsers = false;

    system.copySystemConfiguration = true;

    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 90d";
    };
  };
}
