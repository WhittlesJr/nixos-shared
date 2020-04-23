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
        "scanner"
        "lp"
        "wheel"
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

  hardware.u2f.enable = true;

  # Sound
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  sound.enable = true;
}
