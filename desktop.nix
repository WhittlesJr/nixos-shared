{ stdenv, fetchurl, lib, config, pkgs, ... }:
{
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    #gnomeExtensions.appindicator

    qalculate-gtk

    wine
    winetricks

    pavucontrol

    phoronix-test-suite

    remmina

    vulkan-tools

    ark
    kate
    okular
    kdiff3
    evince
    terminator

    xournal

    firefox
    chromium

    libreoffice-fresh

    discord
    zoom-us

    gnome3.simple-scan

    plexamp
    openvpn
    #googleearth

    #yubiauth-flutter
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


  services.displayManager.sddm.enable = true;

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };
  };
}
