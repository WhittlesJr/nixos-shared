{ lib, config, pkgs, ... }:
{
  networking.firewall.allowPing = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.systemPackages = with pkgs; [
    yubico-pam
    yubikey-personalization
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam = {
    services.sddm.gnupg = {
      storeOnly = true;
      enable = true;
    };
    services.login.gnupg = {
      storeOnly = true;
      enable = true;
    };
    yubico = {
      enable = true;
      debug = true;
      mode = "challenge-response";
    };
  };

  services.openssh = {
    enable = true;
  };
}
