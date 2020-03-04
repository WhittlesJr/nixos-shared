{ lib, config, pkgs, ... }:
let
  readHashedPassword = file:
    lib.fileContents file;
in
{
  users.extraUsers = {
    alexj = {
      isNormalUser = true;
      uid = 1000;
      hashedPassword = readHashedPassword ./alexj.hashedPassword;
      description = "Alex Whitt";
      extraGroups = [ "audio" "cdrom" "media" "wireshark" ];
    };
    root = {
      hashedPassword = readHashedPassword ./alexj-root.hashedPassword;
    };
  };

  environment.systemPackages = with pkgs; [
    emacs-all-the-icons-fonts
    #rambox
  ];

  fonts.fonts = with pkgs; [
    source-code-pro
  ];

  services.emacs = {
    defaultEditor = true;
    install = true;
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  sound.enable = true;
}
