{ lib, config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc
    makemkv
    ccextractor
    mkvtoolnix
    whipper
    picard
    handbrake
    android-file-transfer
  ];

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
