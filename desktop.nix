{ config, pkgs, ... }:
{
  services.redshift = {
    enable = true;
    temperature.night = 1700;
  };

  environment.systemPackages = with pkgs; [
    plasma-browser-integration

    remmina

    ark
    kate
    shutter
    kdeApplications.okular
    kdiff3

    google-chrome
    #chromium

    libreoffice-fresh
  ];

  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages = [
      pkgs.vaapiIntel # Chromium hardware acceleration
    ];
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}
