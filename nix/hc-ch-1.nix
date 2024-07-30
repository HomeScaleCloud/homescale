{ modulesPath, config, pkgs, lib, ... }: {
  imports = [
    ./hardware/dell-r720.nix
    ./modules/base.nix
    ./modules/ch.nix
  ];

  networking = {
    hostName = "hc-ch-1";
  };

  systemd.services.traefik = {
    description = "Traefik (Docker Compose)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    restartIfChanged = true;
    restartTriggers = [ "/etc/morrislan/docker/compose/traefik/docker-compose.yml" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/traefik/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/traefik/docker-compose.yml down";
      WorkingDirectory = "/etc/morrislan/docker/compose/traefik";
      Restart = "always";
      Environment = [ "CLOUDFLARE_TOKEN=SECRETS.CLOUDFLARE_TOKEN" ];
    };
  };

  systemd.services.gitea = {
    description = "Gitea (Docker Compose)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/gitea/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/gitea/docker-compose.yml down";
      WorkingDirectory = "/etc/morrislan/docker/compose/gitea";
      Restart = "always";
      Environment = [ "CI_RUNNER_TOKEN=SECRETS.CI_RUNNER_TOKEN" ];
    };
  };

  systemd.services.cloudflare-tunnel-hc1 = {
    description = "Cloudflare Tunnel (hc1) (Docker Compose)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    restartIfChanged = true;
    restartTriggers = [ "/etc/morrislan/docker/compose/cloudflare-access/hc1/docker-compose.yml" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/cloudflare-access/hc1/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/cloudflare-access/hc1/docker-compose.yml down";
      WorkingDirectory = "/etc/morrislan/docker/compose/cloudflare-access/hc1";
      Restart = "always";
      Environment = [ "CLOUDFLARE_TUNNEL_HC1_TOKEN=SECRETS.CLOUDFLARE_TUNNEL_HC1_TOKEN" ];
    };
  };

  systemd.services.adguard = {
    description = "AdGuard (Docker Compose)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    restartIfChanged = true;
    restartTriggers = [ "/etc/morrislan/docker/compose/adguard/docker-compose.yml" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/adguard/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/adguard/docker-compose.yml down";
      WorkingDirectory = "/etc/morrislan/docker/compose/adguard";
      Restart = "always";
    };
  };

  systemd.services.ai-stack = {
    description = "AI Stack (Docker Compose)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    restartIfChanged = true;
    restartTriggers = [ "/etc/morrislan/docker/compose/ai/docker-compose.yml" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/ai/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/ai/docker-compose.yml down";
      WorkingDirectory = "/etc/morrislan/docker/compose/ai";
      Restart = "always";
      Environment = [ 
        "OPENWEBUI_OAUTH_ID=SECRETS.OPENWEBUI_OAUTH_ID"
        "OPENWEBUI_OAUTH_SECRET=SECRETS.OPENWEBUI_OAUTH_SECRET"
        ];
    };
  };

  systemd.services.authentik = {
    description = "Authentik (Docker Compose)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    restartIfChanged = true;
    restartTriggers = [ "/etc/morrislan/docker/compose/authentik/docker-compose.yml" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/authentik/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/authentik/docker-compose.yml down";
      WorkingDirectory = "/etc/morrislan/docker/compose/authentik";
      Restart = "always";
      Environment = [ 
        "AUTHENTIK_DB_PASS=SECRETS.AUTHENTIK_DB_PASS"
        "AUTHENTIK_SECRET_KEY=SECRETS.AUTHENTIK_SECRET_KEY"
        "AUTHENTIK_PROXY_TOKEN=SECRETS.AUTHENTIK_PROXY_TOKEN"
        "SMTP_HOST=SECRETS.SMTP_HOST"
        "SMTP_USERNAME=SECRETS.SMTP_USERNAME"
        "SMTP_PASSWORD=SECRETS.SMTP_PASSWORD"
        ];
    };
  };

  systemd.services.smart-home = {
    description = "Smart Home (Docker Compose)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    restartIfChanged = true;
    restartTriggers = [ "/etc/morrislan/docker/compose/smart-home/docker-compose.yml" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/smart-home/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/smart-home/docker-compose.yml down";
      WorkingDirectory = "/etc/morrislan/docker/compose/smart-home";
      Restart = "always";
    };
  };

  systemd.services.speedtest = {
    description = "Speedtest (Docker Compose)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    restartIfChanged = true;
    restartTriggers = [ "/etc/morrislan/docker/compose/speedtest/docker-compose.yml" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/speedtest/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/speedtest/docker-compose.yml down";
      WorkingDirectory = "/etc/morrislan/docker/compose/speedtest";
      Restart = "always";
    };
  };

  systemd.services.unifi = {
    description = "UniFi (Docker Compose)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/unifi/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/morrislan/docker/compose/unifi/docker-compose.yml down";
      WorkingDirectory = "/etc/morrislan/docker/compose/unifi";
      Restart = "always";
      Environment = [ "UNIFI_DB_PASS=SECRETS.UNIFI_DB_PASS" ];
    };
  };

  system.stateVersion = "24.05";
}
