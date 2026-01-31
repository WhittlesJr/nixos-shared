{ pkgs, lib, config, ... }:
let
  cfgS = config.my.services.deskflow.server;
  cfgC = config.my.services.deskflow.client;

  thisAddress = config.networking.hostName;
in
with lib;
{
  options.my = {
    services.deskflow.server = {
      enable       = mkEnableOption "Deskflow server for keyboard/mouse sharing";
      serverScreen = mkOption { type = types.str; description = "Direction to client (left/right/up/down)"; };
      clientScreen = mkOption { type = types.str; description = "Direction from client to server"; };
      clientHostName = mkOption { type = types.str; description = "Hostname of the client machine"; };
      port         = mkOption { type = types.port; default = 24800; };
    };
    services.deskflow.client = {
      enable         = mkEnableOption "Deskflow client";
      serverHostName = mkOption { type = types.str; description = "Hostname of the server machine"; };
      serverPort     = mkOption { type = types.port; default = 24800; };
    };
  };

  config = mkMerge [
    (mkIf cfgS.enable {
      networking.firewall.allowedTCPPorts = [ cfgS.port ];

      services.deskflow.server = {
        autoStart = true;
        enable = true;
        configFile = pkgs.writeText "deskflow-server.conf" ''
          section: options
            protocol = barrier
          end

          section: screens
            ${thisAddress}:
            ${cfgS.clientHostName}:
          end

          section: links
            ${thisAddress}:
              ${cfgS.clientScreen} = ${cfgS.clientHostName}
            ${cfgS.clientHostName}:
              ${cfgS.serverScreen} = ${thisAddress}
          end
        '';
      };
    })
    (mkIf cfgC.enable {
      services.deskflow.client = {
        serverAddress = "${cfgC.serverHostName}:${toString cfgC.serverPort}";
        autoStart = true;
        enable = true;
      };
    })
  ];
}
