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

  environment.systemPackages = with pkgs; [
    kwallet-pam
    kdeFrameworks.kwallet
  ];


  services.openssh.enable = true;
}
