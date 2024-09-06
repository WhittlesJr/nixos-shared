{ config, pkgs, lib, ... }:
let
  steam-proton-ge =
    pkgs.stdenv.mkDerivation rec {
      pname = "proton-ge-custom";
      version = "GE-Proton8-20";

      src = pkgs.fetchurl {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
        hash = "sha256-6HPeL0ZUI3Jrc1vt6c5JhsZIVVP08vSKRayqKykbkog=";
      };

      buildCommand = ''
        mkdir -p $out
        tar -C $out --strip=1 -x -f $src
      '';
    };
in
{
  environment.systemPackages = [
    pkgs.evtest
    pkgs.protontricks
    pkgs.ares
    pkgs.prismlauncher
    pkgs.jre8
    pkgs.lutris
    pkgs.antimicrox
    pkgs.betaflight-configurator
  ];

  services.joycond.enable = true;

  # Steam
  programs.steam.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${steam-proton-ge}";
  };
}
