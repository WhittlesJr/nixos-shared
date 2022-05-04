{ lib, config, pkgs, ... }:
{
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    qalculate-gtk

    pavucontrol
    jack2

    phoronix-test-suite

    remmina

    vulkan-tools

    ark
    kate
    okular
    kdiff3

    posterazor

    firefox
    chromium

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

  security.pam.services.sddm.gnupg = {
    storeOnly = true;
    enable = true;
  };

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
