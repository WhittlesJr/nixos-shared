{ config, pkgs, lib, ... }:
with lib;
let
  steam-proton-ge =
    pkgs.stdenv.mkDerivation rec {
      pname = "proton-ge-custom";
      version = "GE-Proton9-25";

      src = pkgs.fetchurl {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
        sha256 = "0bwq384x2bizi08xnh7j3razzzihsqa98ycivfhn5f68r0mkxd2y";
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
      lutris
    ];

    services.joycond.enable = false;

    # Japanese games on wine
    i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];
    i18n.defaultLocale = "en_US.UTF-8";

    # Steam
    programs.steam.enable = true;
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${steam-proton-ge}";
    };
  };
}
