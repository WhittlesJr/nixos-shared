{ lib, config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc                      # Vido + audio playing
    audacity                 # Audio recording and editing
    makemkv                  # Blu-ray / DVD ripping
    ccextractor
    mkvtoolnix
    whipper
    picard
    handbrake                # Video compression
    android-file-transfer
  ];

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
}
