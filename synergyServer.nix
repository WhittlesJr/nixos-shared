{ lib, config, ... }:
let
  cfgS = config.services.synergy.server;
  cfgC = config.services.synergy.client;
in
with lib;
{
  options = {
    services.synergy.server = {
      serverScreen = mkOption { type = types.str; };
      clientScreen = mkOption { type = types.str; };
      clientNode   = mkOption { type = types.anything; };
      port         = mkOption { type = types.port;
                                default = 24800;  };
    };
    services.synergy.client = {
      serverNode = mkOption { type = types.anything; };
    };
  };

  config = mkMerge [
    (mkIf cfgS.enable
      let
        serverAddress = config.networking.hostName;
        clientAddress = cfgS.clientNode.config.networking.hostName;
      in {
        networking.firewall.allowedTCPPorts = [ cfgS.port ];

        services.synergy.server = {
          autoStart = true;
        };

        environment.etc."synergy-server.conf" = {
          enable = true;
          text = ''
            section: screens
              ${serverAddress}:
              ${clientAddress}:
            end

            section: links
              ${serverAddress}:
                ${cfgS.clientScreen} = ${clientName}
              ${clientAddress}:
                ${cfgS.serverScreen} = ${serverAddress}
            end

            section: options
              screenSaverSync = true
            end
          '';
        };
      }
    )

    (mkIf cfgC.enable
      let
        serverAddress = cfgC.serverNode.config.networking.hostName;
        serverPort    = cfgC.serverNode.config.services.synergy.server.port;
      in {
        services.synergy.client = {
          serverAddress = "${serverAddress}:${serverPort}";
          autoStart = true;
        };
      }
    )
  ];
}
