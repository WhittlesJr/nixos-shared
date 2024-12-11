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

        # RDP
        remmina

        # Tools
        ark           # Archive handling
        kate          # Text editor
        qalculate-gtk # Calculator
        kdiff3
        xournal       # PDF Editor
        libreoffice-fresh

        # Browsers
        firefox
        chromium

        # Media
        vlc # Vido + audio playing

      ];

      # Audio
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };

      # Display
      services.displayManager.sddm.enable = true;

      services.xserver = {
        enable = true;
        exportConfiguration = true;
        desktopManager.plasma5 = {
          enable = true;
          runUsingSystemd = true;
        };
      };

      # Adds blu-ray support to VLC
      nixpkgs.overlays = [
        (
          self: super: {
            libbluray = super.libbluray.override {
              withAACS = true;
              withBDplus = true;
            };
          }
        )
      ];
    };
}
