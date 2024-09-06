{ lib, config, pkgs, ... }:
let
  inkscape = pkgs.inkscape-with-extensions.override {
    inkscapeExtensions = [
      #pkgs.inkscape-extensions.inkcut
      #pkgs.inkscape-extensions.silhouette
    ];
  };
in
{
  environment.systemPackages = with pkgs; [
    #inkscape
    #.seamly2d
    posterazor
    gimp
  ];

  hardware.opentabletdriver.enable = true;

  fonts.packages = with pkgs; [
    clearlyU
  ];
}
