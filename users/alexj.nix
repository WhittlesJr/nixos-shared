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
        "networkmanager"
        "input"
        "audio"
        "video"
        "plex"
        "cdrom"
        "media"
        "wireshark"
        "vboxsf"
        "dialout"
        "scanner"
        "lp"
        "wheel"
        "docker"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    ripgrep
    slack
    #everdo
    #rambox
  ];

  fonts.fonts = with pkgs; [
    source-code-pro
    emacs-all-the-icons-fonts
    junicode
  ];

  services.emacs = {
    defaultEditor = true;
    install = true;
  };

}
