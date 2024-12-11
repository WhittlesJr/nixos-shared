{ lib, config, pkgs, ... }:
with lib;
{
  options.my = {
    role.architecture = mkEnableOption "Designing architecture / home modelling";
  };
  config = mkIf config.my.role.architecture {
    environment.systemPackages = with pkgs; [
      sweethome3d.application
      sweethome3d.textures-editor
      sweethome3d.furniture-editor
    ];
  };
}
