{ config, pkgs, lib, ... }:
let
  #steam-proton-tkg =
  #  pkgs.stdenv.mkDerivation rec {
  #    pname = "proton-tkg";
  #    version = "7.6.r12.g51472395";

  #    src = pkgs.fetchurl {
  #      url = "https://github.com/Frogging-Family/wine-tkg-git/releases/download/${version}/proton_tkg_${version}.release.tar.gz";
  #      sha256 = "037mcsxwagfdwpc79z31lravh93mlz4xwna6fv80bivqns4r79kh";
  #    };

  #    buildCommand = ''
  #      mkdir -p $out
  #      tar -C $out --strip=1 -x -f $src
  #    '';
  #  };
  steamtinkerlaunch =
    pkgs.stdenv.mkDerivation rec {
      pname = "steamtinkerlaunch";
      version = "11.0";

      src = pkgs.fetchurl {
        url = "https://github.com/frostworx/steamtinkerlaunch/archive/refs/tags/v${version}.tar.gz";
        sha256 = "11rffqa5xhvf7hxkkxqgvf9ngksv91wd1l3wnysgclcccp78q5sa";
      };

      nativeBuildInputs = with pkgs; [
        makeWrapper
      ];
      postInstall = ''
        substituteInPlace $out/bin/steamtinkerlaunch --replace \
          'PROGCMD="''${0##*/}"' 'PROGCMD="steamtinkerlaunch"'

        wrapProgram $out/bin/steamtinkerlaunch \
          --prefix PATH : ${lib.makeBinPath [
            pkgs.git
            pkgs.gawk
            pkgs.bash
            pkgs.procps
            pkgs.unzip
            pkgs.wget
            pkgs.xdotool
            pkgs.xorg.xprop
            pkgs.xorg.xrandr
            pkgs.unixtools.xxd
            pkgs.xorg.xwininfo
            pkgs.yad
            pkgs.scanmem
            pkgs.gamemode
            pkgs.gamescope
            pkgs.gdb
            pkgs.imagemagick
            pkgs.innoextract
            pkgs.jq
            pkgs.libnotify
            pkgs.mangohud
            pkgs.nettools
            pkgs.p7zip
            pkgs.pev
            pkgs.replay-sorcery
            pkgs.rsync
            pkgs.scummvm
            pkgs.strace
            pkgs.usbutils
            pkgs.vkBasalt
            pkgs.wine
            pkgs.winetricks
            pkgs.xdg-utils
          ]}
      '';

      propagatedBuildInputs = with pkgs; [
      ];

      makeFlags = [
        "PREFIX=$(out)"
      ];
    };
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
    #(pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
    #   theme = "spacefox";
    #})
    steam-proton-ge
    steamtinkerlaunch
  ];

  programs.steam.enable = true;
  #services.joycond.enable = true;

  services.udev.extraRules = ''
    # Nintendo Switch Pro Controller over USB hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:057E:2009.*", MODE="0666"

    # Nintendo Switch Pro Controller over bluetooth hidraw
    KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0666"

    # Permissions for /dev/uinput
    KERNEL=="uinput", MODE="0666", GROUP="users", OPTIONS+="static_node=uinput"
  '';

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${steam-proton-ge}";
  };
}
