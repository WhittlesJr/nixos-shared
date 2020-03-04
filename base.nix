{ lib, config, pkgs, ... }:
{
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

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  users.mutableUsers = false;

  system.copySystemConfiguration = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 90d";
  };
}
