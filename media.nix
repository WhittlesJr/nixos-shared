{ lib, config, pkgs, ... }:
let
  openaudible =
    let
      name = "openaudible";
      version = "3.5.7";
      description = "A cross-platform desktop application for downloading and managing your Audible audiobooks.";

      desktopItem = pkgs.makeDesktopItem {
        name = "OpenAudible";
        exec = name;
        icon = "OpenAudible";
        comment = description;
        desktopName = "OpenAudible";
        genericName = "Audible content downloader";
        categories = [ "AudioVideo" "Audio" ];
      };

      appimageContents = pkgs.appimageTools.extract {
        inherit name src;
      };

      src = pkgs.fetchurl {
        url = "https://github.com/openaudible/openaudible/releases/download/v${version}/OpenAudible_${version}_x86_64.AppImage";
        sha256 = "1hpcz6hdyz8i28sqzwd42h26b8bnadpbxvh70nyh4r9ywvjsysgp";
      };
    in
      pkgs.appimageTools.wrapType1 rec {
        inherit name src;

        extraInstallCommands = ''
          mkdir -p $out/share/applications
          cp ${desktopItem}/share/applications/* $out/share/applications
          #cp -r ${appimageContents}/usr/share/icons/ $out/share/
        '';

        meta = with lib; {
          description = description;
          homepage = "https://openaudible.org/";
          license = with licenses; [ asl20 ];
          maintainers = with maintainers; [ WhittlesJr ];
          platforms = [ "x86_64-linux" ];
        };
      };
in
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

    #openaudible
    appimage-run
    audible-cli
  ];

  # Adds blu-ray support to VLC
  #nixpkgs.overlays = [
  #  (
  #    self: super: {
  #      libbluray = super.libbluray.override {
  #        withAACS = true;
  #        withBDplus = true;
  #      };
  #    }
  #  )
  #];
}
