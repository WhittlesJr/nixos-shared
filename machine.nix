{ lib, config, pkgs, ... }:
{
  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
      efi = {
        canTouchEfiVariables = false;
      };
    };
    tmpOnTmpfs = true;
  };
}
