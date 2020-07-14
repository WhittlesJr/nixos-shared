{ config, pkgs, ... }:
{
  services.redshift = {
    enable = true;
    temperature.night = 1700;
  };

  environment.systemPackages = with pkgs; [
    plasma-browser-integration
    kde-cli-tools
    adobe-reader

    remmina

    ark
    kate
    shutter
    kdeApplications.okular
    kdiff3

    firefox

    libreoffice-fresh

    zoom-us

    gnome3.simple-scan
  ];

  hardware.opengl = {
    driSupport32Bit = true;
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}
