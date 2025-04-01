{ nodes, lib, config, pkgs, is, ... }:
with lib;
{
  imports = [
    ./architecture.nix
    ./access.nix
    ./bash.nix
    ./cloud-server.nix
    ./desktop.nix
    ./development.nix
    #./digitalArt.nix
    ./gaming.nix
    ./laptop.nix
    ./media.nix
    ./3dPrinting.nix
    ./synergy.nix
    ./textiles.nix
  ];
  config = mkMerge [
    {
      services.journald.extraConfig = "Storage=persistent";
      system.copySystemConfiguration = true;
      services.fwupd.enable = true;
      services.thermald.enable = true;
      systemd.coredump.enable = true;
      networking.networkmanager.enable = true;
      programs.git.enable = true;

      zramSwap.memoryPercent = 10;

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        # luls
        cowsay
        fortune
        sl

        # Machine management
        nixops_unstable_minimal


        # hardware
        smartmontools
        mdadm

        # common tools
        unzip
        wget
        unar
        convmv
        vim
        mkpasswd
        tree
        babashka
        psmisc     # For fuser
        lsof       # Helps see processes using a file

      ];

      hardware = {
        enableRedistributableFirmware = true;
        #enableAllFirmware = true;
      };
    }];
}
