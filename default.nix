{ lib, config, pkgs, ... }:
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
      boot.loader.systemd-boot.memtest86.enable = true;
      services.journald.extraConfig = "Storage=persistent";
      # system.copySystemConfiguration is not supported with flakes
      services.fwupd.enable = true;
      services.thermald.enable = true;
      systemd.coredump.enable = true;
      networking.networkmanager.enable = true;
      programs.git.enable = true;

      zramSwap.memoryPercent = 10;

      nixpkgs.config.allowUnfree = true;

      nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
        nettools
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
