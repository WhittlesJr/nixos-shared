{ lib, config, pkgs, ... }:
{
  nix.settings.trusted-users = [ "root" "alexj"];

  users.extraUsers = {
    root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrImXlLCT+qWOjg1rrelUTaUCBurdxf55lWUE0HNua1P5XcErITmRHAsNOWfM0ZMLSpyNWBcNh2XZYhkyCUVsWmEHFXX/xye8o3M0DUqgcxKl//MQ21vzGeVwC7+ierkDScvbh1hW6iDF31Jtu+oYozcu9s/Y+jBOILf/yVzUWayptQcdSyZanYq1A3D5jZZBFOb40E7mv0GR3UAgx7OAHo30Lwl6m1zth3NkiADdRlrTnwkHlcjzX4CLvdh12pBIU+JfpNbaQRJneH+s4YrYgvWsXVVWKfiBzf+OO5xgAEhAXl4Iz4H1u2CSqfG2FDNghHT8fWLRpvIJWJWrl1/FRVQtaAAUGul8E/tmPBPWCmp+/CdbGJ7Skx397tUGL8fkYDa6LzSk9s9EQBxb1yubv65hi8TBLepd4fd+bxOm4+gey2ZHqMIbQQeFRwBMJNZCCBuxagL1GHvUyW5o3qTiIMzw0KOHjy9QkfRWlkTuFHCwYZyL5T4hNFwP7xqFH+ad9Ybd+/ctSShcDcCDqDu6orAUd/D3+NbHpLK7PlKzcivQCvIUoocy7WTNix80pWP8wl2IDK0jr3ZJydHMRk79kp2WE4fOKxeK/UiRmqaU+5QkQn5+yKo3d1DKpUtOJTdj8YzQa3+1J5aAohO1vMxl9RCVweEDKVQbuteQ31WQZ9w== alex.joseph.whitt@gmail.com"
    ];

    alexj = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/alexj";
      hashedPassword = lib.fileContents ./alexj.hashedPassword;
      description = "Alex Whitt";
      extraGroups = [
        "wireshark"
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
        "plugdev"
        "scanner"
        "lp"
        "wheel"
        "docker"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    ripgrep
    emacsPackages.vterm
    ispell
    #everdo
    #rambox
  ];

  fonts.packages = with pkgs; [
    source-code-pro
    emacs-all-the-icons-fonts
    junicode
  ];

  services.emacs = {
    package = pkgs.emacs29;
    defaultEditor = true;
    install = true;
  };

}
