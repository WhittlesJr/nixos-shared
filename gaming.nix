{ config, pkgs, ... }:
let
  steam-proton-ge =
    pkgs.stdenv.mkDerivation rec {
      pname = "proton-ge-custom";
      version = "GE-Proton7-27";

      src = pkgs.fetchurl {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
        sha256 = "07p6dskl1rp39kkbjw4s36rs2dhmr15dj7h17ly2ckm2lsk2miss";
      };

      buildCommand = ''
        mkdir -p $out
        tar -C $out --strip=1 -x -f $src
      '';
    };
in
{
  environment.systemPackages = [
    pkgs.discord
    pkgs.xboxdrv   # For Nintendo Switch pro controllers
    pkgs.evtest
    pkgs.protontricks
    steam-proton-ge
  ];

  programs.steam.enable = true;
  services.joycond.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${steam-proton-ge}";
  };
}
