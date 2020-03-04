{ lib, config, pkgs, ... }:
{
  users.extraUsers = {
    alexj = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/alexj";
      hashedPassword = lib.fileContents ./alexj.hashedPassword;
      description = "Alex Whitt";
      extraGroups = [
        "audio"
        "cdrom"
        "media"
        "wireshark"
        "vboxsf"
        "dialout"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    ripgrep
    #rambox
  ];

  fonts.fonts = with pkgs; [
    source-code-pro
    emacs-all-the-icons-fonts
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