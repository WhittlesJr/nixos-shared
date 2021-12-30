{ lib, config, pkgs, ... }:
{
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    plasma-browser-integration
    kde-cli-tools
    qalculate-gtk

    pavucontrol
    jack2

    phoronix-test-suite

    remmina

    vulkan-tools

    ark
    kate
    shutter
    okular
    kdiff3

    posterazor

    firefox
    google-chrome

    libreoffice-fresh

    discord
    zoom-us

    gnome3.simple-scan

    plexamp
    openvpn
    googleearth
    gimp
    posterazor

    yubioath-desktop

    plasma-pa

    libsForQt5.qt5.qtgraphicaleffects # For Thermal Monitor widget
  ];

  hardware.opengl = {
    driSupport32Bit = true;
    enable = true;
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
