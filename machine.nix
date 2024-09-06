{ lib, config, pkgs, ... }:
{
  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  services.fwupd.enable = true;

  #environment.systemPackages = with pkgs; [
  #  lm_sensors
  #];

  boot = {
    kernel.sysctl = {
      "vm.vfs_cache_pressure" = 200;
    };
    loader = {
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
      efi = {
        canTouchEfiVariables = false;
      };
    };
    tmp.useTmpfs = true;
  };
}
