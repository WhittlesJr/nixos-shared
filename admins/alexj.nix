{ lib, config, pkgs, ... }:
{
  users.extraUsers = {
    alexj = {
      isNormalUser = true;
      uid = 1000;
      hashedPassword = lib.fileContents ./alexj.hashedPassword;
      description = "Alex Whitt";
      extraGroups = [ "audio" "cdrom" "media" "wireshark" ];
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
