{ lib, config, pkgs, ... }:
let
  inkscape = pkgs.inkscape-with-extensions.override {
    inkscapeExtensions = [
      #pkgs.inkscape-extensions.inkcut
      pkgs.inkscape-extensions.silhouette
    ];
  };
in
{
  environment.systemPackages = [
    inkscape
  ];
}
