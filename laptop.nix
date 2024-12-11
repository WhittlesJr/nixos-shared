{ lib, pkgs, ... }:
with lib;
{
  options.my = {
    machine.isLaptop = mkEnableOption "Running videogames";
  };

  config = mkIf config.my.machine.isLaptop {

    services.xserver.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
        clickMethod = "buttonareas";
        scrollMethod = "twofinger";
        accelProfile = "adaptive";
      };
    };

    environment.systemPackages = with pkgs; [
      libinput
    ];

    services.logind.lidSwitchExternalPower = "lock";
  };
}
