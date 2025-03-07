{ lib, config, pkgs, ... }:
let
  cfg = config.my.services;
  anythingEnabled = (cfg.plex || cfg.calibre || cfg.nextCloud);
in
with lib;
{
  options.my.services = {
    plex       = mkEnableOption {};
    calibre    = mkEnableOption {};
    nextCloud  = mkEnableOption {};
    anki       = mkEnableOption {};
    webDomain  = mkOption { type = types.str; };
    mediaRoot  = mkOption { type = types.str; };
    adminEmail = mkOption { type = types.str; };
    adminPasswordFile = mkOption { type = types.str; };
  };

  config = mkMerge [

    # Base
    (mkIf anythingEnabled {
      users.extraGroups = {
        media = {};
      };
      networking.firewall = {
        allowedTCPPorts = [ 80 443 ];
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
    (mkIf cfg.plex {
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
    (mkIf cfg.calibre {
      services.nginx = {
        virtualHosts =
          {"${cfg.webDomain}" = {
             locations."/calibre" = {
               proxyPass = "http://127.0.0.1:8083/";
               root = "/var/www/calibre";
               extraConfig =
                 "proxy_busy_buffers_size        1024k;" +
                 "proxy_buffers                  4 512k;" +
                 "proxy_buffer_size              1024k;" +
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
      environment.systemPackages = with pkgs; [
        calibre
      ];

    })

    # Anki
    (mkIf cfg.anki {
      #services.anki-sync-server = {
      #  enable = false;
      #  host = "127.0.0.1";
      #  port = 27701;
      #  openFirewall = true;
      #  #users = [{username = "adminhraidstn";
      #  #          password = "passwordhraidstn";}];
      #};
      services.nginx = {
        virtualHosts = {
          "${cfg.webDomain}" = {
            locations."/anki" = {
              proxyPass = "http://127.0.0.1:27701/";
              root = "/var/www/anki";
              extraConfig = ''
                proxy_http_version             1.0;
                proxy_set_header X-Script-Name /anki;
                proxy_set_header X-Scheme      $scheme;
                client_max_body_size           222M;
              '';
            };
          };
        };
      };
    })

    # NextCloud
    (mkIf cfg.nextCloud {
      services.nginx = {
        virtualHosts =
          {
            "localhost" = {
              listen = [ { addr = "127.0.0.1"; port = 8080; } ];
            };
            "${cfg.webDomain}" = {
              locations."/nextcloud" = {
                proxyPass = "http://127.0.0.1:8080/";
                root = "/var/www/nextcloud";
                extraConfig =
                  "proxy_set_header X-Script-Name /nextcloud;" +
                  "proxy_set_header X-Scheme      $scheme;";
              };
            };
          };
      };
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud25;
        hostName = "localhost";
        extraApps = with pkgs.nextcloud25Packages.apps; {
          inherit mail news contacts deck files_texteditor keeweb notes onlyoffice tasks twofactor_totp notify_push;
        };
        extraAppsEnable = true;
        enableBrokenCiphersForSSE = false;
        config.adminpassFile = cfg.adminPasswordFile;
        extraOptions = {
          mail_smtpmode = "sendmail";
          mail_sendmailmode = "pipe";
        };
      };
    })
  ];
}
