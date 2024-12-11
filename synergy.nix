{ lib, config, ... }:
let
  cfgS = config.my.services.synergy.server;
  cfgC = config.my.services.synergy.client;

  thisAddress = config.networking.hostName;
  clientAddress = cfgS.clientNode.config.networking.hostName;

  serverAddress = cfgC.serverNode.config.networking.hostName;
  serverPort    = cfgC.serverNode.config.services.synergy.server.port;
in
with lib;
{
  options.my = {
    services.synergy.server = {
      enable       = mkEnableOption "Synergy setup using NixOps nodes";
      serverScreen = mkOption { type = types.str; };
      clientScreen = mkOption { type = types.str; };
      clientNode   = mkOption {};
      port         = mkOption { type = types.port;
                                default = 24800;  };
    };
    services.synergy.client = {
      serverNode = mkOption {};
    };
  };

  config = mkMerge [
    (mkIf cfgS.enable {
      networking.firewall.allowedTCPPorts = [ cfgS.port ];

      services.synergy.server = {
        autoStart = true;
      };

      environment.etc."synergy-server.conf" = {
        enable = true;
        text = ''
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
      services.synergy.client = {
        serverAddress = "${serverAddress}:${toString serverPort}";
        autoStart = true;
      };
    })
  ];
}
