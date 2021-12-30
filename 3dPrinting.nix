{ lib, config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    blender
    slic3r
    (cura.override {
      plugins = with curaPlugins; [ octoprint ];
    })
    platformio
    printrun
    openscad
  ];

  services.octoprint = {
    enable = true;
    plugins = plugins: with plugins; [
      titlestatus
      printtimegenius
    ];
    extraConfig = {
      plugins = {
        temperature = {
          profiles = [{
            bed = 100;
            chamber = null;
            extruder = 210;
            name = "ABS";
          }{
            bed = 60;
            chamber = null;
            extruder = 180;
            name = "PLA";
          }];
        };
      };
    };
  };

  users.extraUsers = {
    octoprint = {
      extraGroups = [ "dialout" ];
    };
  };
}
