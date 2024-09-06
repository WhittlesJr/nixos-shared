{ nodes, lib, config, pkgs, ... }:
with lib;
{
  deployment.targetHost = config.networking.hostName;

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
    "nixos-config=/run/current-system/configuration.nix"
  ];

  i18n = {
    supportedLocales = [ "all" ];
    defaultLocale = "en_US.UTF-8";
  };

  #nix.distributedBuilds = true;
  nix.buildMachines = mapAttrsToList
    (name: node: {hostName = node.config.networking.hostName;
                  system = "x86_64-linux";
                  maxJobs = node.config.nix.settings.max-jobs;})
    nodes;

  users.extraUsers = {
    root = {
      hashedPassword = lib.fileContents ./users/root.hashedPassword;
    };
  };

  services.journald.extraConfig = "Storage=persistent";

  services.mullvad-vpn.enable = true;

  environment.systemPackages = with pkgs; [
    cowsay
    dmidecode
    dnsutils
    fortune
    git
    file
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
    mkpasswd
    ncdu
    nix-index
    nixops_unstable_minimal
    nixpkgs-review
    nix-index
    nix-prefetch
    nix-prefetch-git
    ntfs3g
    openssl
    p7zip
    unrar
    parted
    patchutils
    pciutils
    psmisc
    sl
    smartmontools
    tree
    unzip
    usbutils
    vim
    wget
    babashka
    zip
  ];

  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;

  system.copySystemConfiguration = true;

  services.thermald.enable = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 90d";
  };
}
