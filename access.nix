{ lib, config, pkgs, ... }:
{
  networking.firewall.allowPing = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  services.openssh.enable = true;
}
