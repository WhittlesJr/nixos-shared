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
    (if true then {
      deployment.targetHost = config.networking.hostName;

      #nix.distributedBuilds = true;
      nix.buildMachines =
        (mapAttrsToList
          (name: node: {hostName = node.config.networking.hostName;
                        system = "x86_64-linux";
                        maxJobs = node.config.nix.settings.max-jobs;})
          nodes);
    } else {})
    {
      services.journald.extraConfig = "Storage=persistent";
      system.copySystemConfiguration = true;
      services.fwupd.enable = true;
      services.thermald.enable = true;
      systemd.coredump.enable = true;
      networking.networkmanager.enable = true;
      programs.git.enable = true;

      environment.systemPackages = with pkgs; [
        # luls
        cowsay
        fortune
        sl

        # Machine management
        nixops_unstable_minimal


        # hardware
        smartmontools

        # common tools
        vim
        mkpasswd
        tree
        babashka
      ];

      hardware = {
        enableRedistributableFirmware = true;
        #enableAllFirmware = true;
      };
    }];
}
