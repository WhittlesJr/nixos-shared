{ lib, config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    blender
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
      mqtt titlestatus stlviewer printtimegenius abl-expert
      gcodeeditor simpleemergencystop
    ];
    extraConfig = {
      plugins = {
        ABL_Expert = {
          eeprom_save = false;
          max_index = 2;
          preheat_bed_only = true;
          preheat_selected = "PLA";
        };
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
