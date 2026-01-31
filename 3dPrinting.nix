{ lib, config, pkgs, ... }:
with lib;
{
  options.my = {
    role.modeling3D = mkEnableOption "3D modeling";
    services.printing3D = mkEnableOption "3D printer service via octoprint";
  };

  config = mkMerge[
    (mkIf config.my.role.modeling3D {
      environment.systemPackages = with pkgs; [
        platformio
        blender
        super-slicer
        printrun
        openscad
      ];

    })
    (mkIf config.my.services.printing3D {
      services.octoprint = {
        enable = true;
        plugins = plugins: with plugins; [
          titlestatus
          #printtimegenius
        ];
        openFirewall = true;
        host = null;
        extraConfig = {
          plugins = {
            softwareupdate = {
              checks = {
                octoprint = {
                  method = "update_script";
                };
              };
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
    })];
}
