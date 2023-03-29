{ lib, config, pkgs, ... }:
let
  cfg = config.cloudServer;
  anythingEnabled = (cfg.enablePlex || cfg.enableCalibre || cfg.enableNextCloud);
in
with lib;
{
  options = {
    cloudServer = {
      enablePlex      = mkEnableOption {};
      enableCalibre   = mkEnableOption {};
      enableNextCloud = mkEnableOption {};
      webDomain  = mkOption { type = types.str; };
      mediaRoot  = mkOption { type = types.str; };
      adminEmail = mkOption { type = types.str; };
    };
  };

  config = mkMerge [

    # Base
    (mkIf anythingEnabled {
      users.extraGroups = {
        media = {};
      };
      networking.firewall = {
        allowedTCPPorts = [ 80 443 ];
        #allowedUDPPorts = [ 80 443 ];
      };
      security.acme = {
        acceptTerms = true;
        defaults.email = cfg.adminEmail;
      };
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "${cfg.webDomain}" = {
            forceSSL = true;
            enableACME = true;
          };
        };
      };
    })

    # Plex
    (mkIf cfg.enablePlex {
      services.plex = {
        enable = true;
        openFirewall = true;
        dataDir = "${cfg.mediaRoot}/.plex";
      };
      users.extraUsers.plex.extraGroups = [ "media" ];

      environment.systemPackages = with pkgs; [
        sqlite
      ];
    })

    # Calibre
    (mkIf cfg.enableCalibre {
      services.nginx = {
        virtualHosts =
          {"${cfg.webDomain}" = {
             locations."/calibre" = {
               proxyPass = "http://127.0.0.1:8083/";
               root = "/var/www/calibre";
               extraConfig =
                 "proxy_set_header X-Script-Name /calibre;" +
                 "proxy_set_header X-Scheme      $scheme;";
             };
           };
          };
      };
      services.calibre-server = {
        enable = false;
        libraries = [
          "${cfg.mediaRoot}/Ebooks"
        ];
      };
      services.calibre-web = {
        enable = true;
        openFirewall = true;
        listen.ip = "127.0.0.1";
        options = {
          enableBookUploading = true;
          enableBookConversion = true;
          calibreLibrary = "${cfg.mediaRoot}/Ebooks";
        };
      };
      users.extraUsers.calibre-web.extraGroups = [ "media" ];
      #users.extraUsers.calibre-server.extraGroups = [ "media" ];
    })


    # NextCloud
    (mkIf cfg.enableNextCloud {
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud25;
        hostName = "localhost";
        extraApps = with pkgs.nextcloud25Packages.apps; {
          inherit mail news contacts deck files_texteditor keeweb notes onlyoffice tasks twofactor_totp; #notify_push
        };
        extraAppsEnable = true;
        enableBrokenCiphersForSSE = false;
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        extraOptions = {
          mail_smtpmode = "sendmail";
          mail_sendmailmode = "pipe";
        };
      };
    })
  ];
}
