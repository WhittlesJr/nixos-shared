{ pkgs, lib, config, ... }:
let
  cfgS = config.my.services.deskflow.server;
  cfgC = config.my.services.deskflow.client;

  thisAddress = config.networking.hostName;
  clientAddress = cfgS.clientNode.config.networking.hostName;

  serverAddress = cfgC.serverNode.config.networking.hostName;
  serverPort    = cfgC.serverNode.config.my.services.deskflow.server.port;
in
with lib;
{
  options.my = {
    services.deskflow.server = {
      enable       = mkEnableOption "Synergy setup using NixOps nodes";
      serverScreen = mkOption { type = types.str; };
      clientScreen = mkOption { type = types.str; };
      clientNode   = mkOption {};
      port         = mkOption { type = types.port;
                                default = 24800;  };
    };
    services.deskflow.client = {
      serverNode = mkOption {};
      enable     = mkEnableOption "Synergy client";
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
            ${clientAddress}:
          end

          section: links
            ${thisAddress}:
              ${cfgS.clientScreen} = ${clientAddress}
            ${clientAddress}:
              ${cfgS.serverScreen} = ${thisAddress}
          end
        '';
      };
    })
    (mkIf cfgC.enable {
      services.deskflow.client = {
        serverAddress = "${serverAddress}:${toString serverPort}";
        autoStart = true;
        enable = true;
      };
    })
  ];
}
