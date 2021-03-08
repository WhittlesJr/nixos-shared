{ lib, config, pkgs, ... }:
{
  networking.networkmanager.enable = true;

  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  services.redshift = {
    enable = true;
    temperature.night = 1700;
  };

  environment.systemPackages = with pkgs; [
    kwallet-pam
    kdeFrameworks.kwallet
    ksshaskpass

    plasma-browser-integration
    kde-cli-tools
    qalculate-gtk

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

    plexamp
    googleearth
    gimp
  ];

  hardware.opengl = {
    driSupport32Bit = true;
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  sound.enable = true;

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}
