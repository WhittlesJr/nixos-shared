{ lib, config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc                      # Vido + audio playing
    audacity                 # Audio recording and editing
    makemkv                  # Blu-ray / DVD ripping
    ccextractor              # For makemkv
    mkvtoolnix
    whipper
    picard                   # Music library management
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
