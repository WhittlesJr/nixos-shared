{ stdenv, fetchurl, lib, config, pkgs, ... }:
with lib;
{
  options = {
    my.role.desktop = mkEnableOption "Desktop computer with GUI";
  };

  config = mkIf config.my.role.desktop
    {
      environment.systemPackages = with pkgs; [
        # Windows
        wine
        winetricks

        # Audio
        pavucontrol

        # Graphics
        phoronix-test-suite # Graphics performance test
        vulkan-tools

        # Proton
        protonvpn-gui
        proton-pass

        # RDP
        remmina

        # Tools
        gimp             # Image editing
        kdePackages.ark  # Archive handling
        kdePackages.kate # Text editor
        qalculate-gtk    # Calculator
        kdiff3
        xournalpp        # PDF Editor
        libreoffice-fresh
        xorg.xkill

        # Browsers
        brave
        tor-browser
        firefox
      ];

      hardware.graphics.enable32Bit = true;
      hardware.graphics.enable = true;

      # Audio
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };

      # VMs
      virtualisation.virtualbox.host = {
        enable = false;
        enableExtensionPack = true;
      };

      # Display
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6.enable = true;
      programs.xwayland.enable = true;
    };
}
