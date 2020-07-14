{ lib, config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #aacskeys
    vlc
    makemkv
    ccextractor
    mkvtoolnix
    sound-juicer
    picard
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
