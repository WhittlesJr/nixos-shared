{ lib, config, pkgs, ... }:
{
  networking.firewall.allowPing = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
}
