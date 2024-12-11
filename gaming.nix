{ config, pkgs, lib, ... }:
with lib;
let
  steam-proton-ge =
    pkgs.stdenv.mkDerivation rec {
      pname = "proton-ge-custom";
      version = "GE-Proton9-20";

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
  options.my = {
    role.gaming = mkEnableOption "Running videogames";
  };

  config = mkIf config.my.role.gaming {
    environment.systemPackages = with pkgs; [
      protontricks
      jre8
      evtest        # Monitor input events
      ares          # Retro game emulator
      lutris        # Installer script helper for games
      antimicrox    # Gamepad button mapping
    ];

    services.joycond.enable = true;

    # Steam
    programs.steam.enable = true;

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${steam-proton-ge}";
    };
  };
}
