{ lib, config, pkgs, ... }:
{
  networking.networkmanager.enable = true;

  services.redshift = {
    enable = true;
    temperature.night = 1700;
  };

  environment.systemPackages = with pkgs; [
    plasma-browser-integration
    kde-cli-tools
    qalculate-gtk

    phoronix-test-suite

    remmina

    ark
    kate
    shutter
    okular
    kdiff3

    firefox

    libreoffice-fresh

    discord
    zoom-us

    gnome3.simple-scan

    plexamp
    googleearth
    gimp
    posterazor

    yubioath-desktop

    plasma-pa

  ];

  hardware.opengl = {
    driSupport32Bit = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  sound.enable = true;

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5 = {
      enable = true;
    };
  };
}
