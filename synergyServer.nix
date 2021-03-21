{ lib, config, ... }:
let
  cfg = config.services.synergy.server;
in
with lib;
{
  options = {
    services.synergy.server = {
      left  = mkOption { type = types.str;};
      right = mkOption { type = types.str;};
      port  = mkOption { type = types.port;
                         default = 24800;};
    };
  };

  config = {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.synergy.server = {
      enable = true;
      autoStart = true;
    };

    environment.etc."synergy-server.conf" = {
      enable = true;
      text = ''
        section: screens
          ${cfg.left}:
          ${cfg.right}:
        end

        section: links
          ${cfg.left}:
            right = ${cfg.right}
          ${cfg.right}:
            left = ${cfg.left}
        end

        section: options
          screenSaverSync = true
        end
      '';
    };

  };
}
