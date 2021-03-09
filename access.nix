{ lib, config, pkgs, ... }:
{
  networking.firewall.allowPing = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Depending on the details of your configuration, this section might be
  # necessary or not; feel free to experiment
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.yubico = {
    enable = true;
    debug = true;
    mode = "challenge-response";
  };

  programs.ssh.startAgent = false;
}
