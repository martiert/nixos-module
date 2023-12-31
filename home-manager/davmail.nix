{ config, lib, pkgs, libXtst, ... }:

with lib;

let
  martiert = config.martiert;

  # Disable JavaFX to use the simple pop-up
  jre = pkgs.openjdk.override {
    enableJavaFX = false;
  };
  davmail = pkgs.davmail.override {
    preferZulu = false;
  };
  java_opts = "-Xmx512M -Dsun.net.inetaddr.ttl=60 -Djdk.gtk.version=3";
in {
  config = mkIf (martiert.system.type == "desktop") {
    home.packages = [
      davmail
    ];

    home.file.".davmail.properties".text = ''
      davmail.server=true
      davmail.allowRemote=false
      davmail.disableUpdateCheck=true

      # Send keepalive character during large folder and messages download
      davmail.enableKeepalive=false
      # Message count limit on folder retrieval
      davmail.folderSizeLimit=0

      # Delete messages immediately on IMAP STORE \Deleted flag
      # davmail.imapAutoExpunge=true
      # Enable IDLE support, set polling delay in minutes
      davmail.imapIdleDelay=
      # Always reply to IMAP RFC822.SIZE requests with Exchange approximate message size for performance reasons
      davmail.imapAlwaysApproxMsgSize=

      # SSL
      davmail.ssl.nosecureimap=true

      # log file path, leave empty for default path
      davmail.logFilePath=./logs/davmail.log
      # maximum log file size, use Log4J syntax, set to 0 to use an external rotation mechanism, e.g. logrotate
      davmail.logFileSize=1MB
      # log levels
      log4j.logger.davmail=INFO
      log4j.logger.httpclient.wire=WARN
      log4j.logger.org.apache.commons.httpclient=WARN
      log4j.rootLogger=INFO
    '' + (if ! martiert.email.davmail.o365.enable then "" else ''
        davmail.mode=O365Interactive
        davmail.url=https://outlook.office365.com/EWS/Exchange.asmx
        davmail.oauth.clientId=${martiert.email.davmail.o365.clientId}
        davmail.oauth.redirectUri=${martiert.email.davmail.o365.redirectUri}
        davmail.oauth.persistToken=true
        davmail.imapPort=${toString martiert.email.davmail.imapPort}
        davmail.caldavPort=${toString martiert.email.davmail.caldavPort}
      '');

    systemd.user.services.davmail = {
      Unit = {
        Description = "Davmail Exchange IMAP Proxy";
        After = "graphical-session-pre.target";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${jre}/bin/java ${java_opts} -cp ${davmail}/share/davmail/davmail.jar davmail.DavGateway";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
